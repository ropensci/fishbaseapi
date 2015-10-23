class Base < ActiveRecord::Base
  attr_accessor :with_id

  self.abstract_class = true
  self.pluralize_table_names = false

  def self.endpoint(params)
    %i(limit offset).each do |p|
      unless params[p].nil?
        begin
          params[p] = Integer(params[p])
        rescue ArgumentError
          raise Exception.new("#{p.to_s} is not an integer")
        end
      end
    end
    raise Exception.new('limit too large (max 5000)') unless params[:limit] <= 5000
    return where(primary_key => params[:id]) if params[:id]
    fields = columns.map(&:name)
    where(params.select { |param| fields.include?(param) })
        .limit(params[:limit])
        .offset(params[:offset])
        .select(params[:fields])
  end
end
