class Base < ActiveRecord::Base
  attr_accessor :with_id

  self.abstract_class = true
  self.pluralize_table_names = false

  def self.endpoint(params)
    return where(primary_key => params[:id]) if params[:id]
    fields = columns.map(&:name)
    where(params.select { |param| fields.include?(param) })
        .limit(params[:limit])
        .offset(params[:offset])
  end
end
