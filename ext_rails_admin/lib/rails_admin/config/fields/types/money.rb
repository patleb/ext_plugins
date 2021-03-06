if defined?(MoneyRails)
  require 'money-rails/helpers/action_view_extension'

  include MoneyRails::ActionViewExtension

  module RailsAdmin
    module Config
      module Fields
        module Types
          class Money < RailsAdmin::Config::Fields::Types::Integer
            RailsAdmin::Config::Fields::Types::register(self)

            register_instance_option :pretty_value do
              humanized_money_with_symbol(value)
            end
          end
        end
      end
    end
  end
end
