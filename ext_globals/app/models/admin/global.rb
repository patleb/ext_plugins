module Admin::Global
  extend ActiveSupport::Concern

  included do
    rails_admin do
      configure :id do
        read_only true
        help false
      end

      configure :data do
        pretty_value{ simple_format(truncate(m.data.to_s, length: ExtGlobals.config.output_length)) }
      end

      configure :type do
        read_only true
        help false
      end

      show do
        exclude_fields :type, :data
      end

      list do
        include_fields :id, :expires, :type, :data, :updated_at
      end

      edit do
        field :id
        field :expires
        included_types = Global.types.keys.reject!{ |type| type.end_with?('s') }
        included_types.each do |type|
          field type, type do
            visible do
              m.type == type
            end
          end
        end
      end
    end
  end
end
