require 'bundler/setup'
%w(yaml json csv digest).each { |req| require req }
Bundler.require(:default)
require 'sinatra'
require_relative 'models/models'

# feature flag: toggle redis
$use_redis = true

$config = YAML::load_file(File.join(__dir__, ENV['RACK_ENV'] == 'test' ? 'test_config.yaml' : 'config.yaml'))

$redis = Redis.new host: ENV.fetch('REDIS_PORT_6379_TCP_ADDR', 'localhost'),
                   port: ENV.fetch('REDIS_PORT_6379_TCP_PORT', 6379)

ActiveSupport::Deprecation.silenced = true
ActiveRecord::Base.establish_connection($config['db']['fb_201703'])

class API < Sinatra::Application
  before do
    # puts '[env]'
    # p env
    # puts '[Params]'
    # p params
    # puts '[request.url]'
    # p request.url

    $route = request.path

    # prevent certain verbs
    if request.request_method != 'GET'
      halt 405
    end

    # sort out database version as needed for caching
    ## sealifebase or fishbase
    @slb_or_fb = request.script_name == '/sealifebase' ? 'slb' : 'fb'
    ## database version if fishbase
    if @slb_or_fb == "fb"
      ver_h = request.env['HTTP_ACCEPT']
      ver_h = ver_h.split(',').keep_if { |x| x.match(/application\/vnd\.ropensci/) }[0]
      ver_h = ver_h || "application/vnd.ropensci.v3+json"
      ver_h = ver_h[/v[0-9]/]

      case ver_h
      when "v1"
        ver_c = "201505"
      when "v2"
        ver_c = "201604"
      when "v3"
        ver_c = "201703"
      else
        ver_c = "201712" # use newest by default
      end
      @slb_or_fb = "fb_" + ver_c
    end

    # use redis caching
    if $config['caching'] && $use_redis
      if request.path_info != "/"
        @cache_key = Digest::MD5.hexdigest(request.url + '_ver_' + @slb_or_fb)
        if $redis.exists(@cache_key)
          headers 'Cache-Hit' => 'true'
          halt 200, {
            'Content-Type' => 'application/json; charset=utf8',
            'Access-Control-Allow-Methods' => 'HEAD, GET',
            'Access-Control-Allow-Origin' => '*'},
            $redis.get(@cache_key)
        end
      end
    end

    # set correct db connection
    ActiveRecord::Base.establish_connection($config['db'][@slb_or_fb])

    # set headers
    headers 'Content-Type' => 'application/json; charset=utf8'
    headers 'Access-Control-Allow-Methods' => 'HEAD, GET'
    headers 'Access-Control-Allow-Origin' => '*'
    headers 'X-Database-Version' => @slb_or_fb
    cache_control :public, :must_revalidate, max_age: 60
  end

  after do
    # cache response in redis
    if $config['caching'] &&
      $use_redis &&
      !response.headers['Cache-Hit'] &&
      response.status == 200 &&
      request.path_info != "/" &&
      request.path_info != ""

      $redis.set(@cache_key, response.body[0], ex: $config['caching']['expires'])
    end
  end

  configure do
    mime_type :apidocs, 'text/html'
  end

  # handle missed route
  not_found do
    halt 404, { error: 'route not found' }.to_json
  end

  # handle other errors
  error do
    halt 500, { error: 'server error' }.to_json
  end

  # handler - redirects any /foo -> /foo/
  #  - if has any query params, passes to handler as before
  get %r{(/.*[^\/])} do
    if request.query_string == "" or request.query_string.nil?
      redirect request.script_name + "#{params[:captures].first}/"
    else
      pass
    end
  end

  # default to landing page
  ## used to go to /heartbeat
  get '/?' do
    @slb_or_fb = request.script_name == '/sealifebase' ? '/index_sb.html' : '/index.html'
    content_type :apidocs
    send_file File.join(settings.public_folder, @slb_or_fb)
  end

  # route listing route
  get '/heartbeat/?' do
    db_routes = Models.models.map do |m|
      "/#{m.downcase}#{Models.const_get(m).primary_key ? '/:id' : '' }?<params>"
    end
    { routes: %w( /docs/:table? /heartbeat /mysqlping /listfields ) + db_routes }.to_json
  end

  # docs route
  get '/docs/?:table?/?' do
    table = params[:table] || 'tables'
    filename = "docs/docs-sources/#{table}.csv"
    halt not_found unless File.exists?(filename)
    hash = CSV.new(File.read(filename), headers: true).map { |row| row.to_hash }
    { count: hash.length, returned: hash.length, data: hash, error: nil }.to_json
  end

  # db status route
  get '/mysqlping/?' do
    {
        mysql_server_up: true,
        mysql_host: $config['db'][@slb_or_fb]['host']
    }.to_json
  end

  # list fields route
  get '/listfields/?' do
    fields, exact = params[:fields], params[:exact]
    data = Models.list_fields($config['db'][@slb_or_fb]['database'])
    unless fields.nil?
      fields = fields.gsub(',', '|')
      fields = fields.split('|').map { |field| "^#{field}$" }.join('|') if exact
      data.keep_if { |a| a[:column_name].match(fields) }
    end
    { count: data.length, returned: data.length, data: data, error: nil }.to_json
  end

  # database versions
  get '/versions/?' do
    if @slb_or_fb == "slb"
      halt 400, { data: nil, error: { message: "versions route not available for sealifebase" }}.to_json
    else
      {
        data: [
          {
            version: "v1",
            name: "201505",
            date_released: "2015-05-20"
          },
          {
            version: "v2",
            name: "201604",
            date_released: "2016-04-28"
          },
          {
            version: "v3",
            name: "201703",
            date_released: "2017-03-31"
          },
          {
            version: "v4",
            name: "201712",
            date_released: "2017-12-13"
          }
        ],
        error: nil
      }.to_json
    end
  end

  # generate routes from the models
  Models.models.each do |model_name|
    model = Models.const_get(model_name)
    get "/#{model_name.to_s.downcase}/?#{model.primary_key ? ':id?/?' : '' }" do
      begin
        data = model.endpoint(params)
        raise Exception.new('no results found') if data.length.zero?
        { count: data.limit(nil).count(1), returned: data.length, data: data, error: nil }.to_json
      rescue Exception => e
        halt 400, { count: 0, returned: 0, data: nil, error: { message: e.message }}.to_json
      end
    end
  end
end
