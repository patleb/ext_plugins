RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  extensions = [:id, :filename, :size, :content_type]
  model = parent.abstract_model.model
  if (properties.name.to_s =~ /^(.+)_id$/) && defined?(::Refile) && model.ancestors.map(&:to_s).include?("Refile::Attachment(#{attachment_name = Regexp.last_match[1].to_sym})")
    field = RailsAdmin::Config::Fields::Types.load(:refile).new(parent, attachment_name, properties)
    children_fields = []
    extensions.each do |ext|
      children_column_name = "#{attachment_name}_#{ext}".to_sym
      next unless child_properties = parent.abstract_model.properties.detect { |p| p.name.to_s == children_column_name.to_s }
      children_field = fields.detect { |f| f.name == children_column_name } || RailsAdmin::Config::Fields.default_factory.call(parent, child_properties, fields)
      children_field.hide
      children_field.filterable(false)
      children_fields << children_field.name
    end
    field.children_fields(children_fields)
    fields << field
    true
  else
    false
  end
end
