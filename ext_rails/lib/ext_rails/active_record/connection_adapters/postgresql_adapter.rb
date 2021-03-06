require "active_record/connection_adapters/postgresql_adapter"
require_rel 'postgresql'
require_rel 'postgresql_adapter'

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
  include ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::WithCounterCache
  include ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::WithEnum
  prepend ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::WithInterval

  def type_exists?(name)
    select_value("SELECT COUNT(*) FROM pg_type WHERE typname = '#{name}'").to_i > 0
  end
  alias_method :enum_exists?, :type_exists?

  def function_exists?(name)
    select_value("SELECT COUNT(*) FROM pg_proc WHERE proname = '#{name}'").to_i > 0
  end

  def trigger_exists?(table, name)
    select_value("SELECT COUNT(*) FROM pg_trigger WHERE NOT tgisinternal AND tgrelid = '#{table}'::regclass AND tgname = '#{name}'").to_i > 0
  end

  ActiveRecord::Type.register(:interval, ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID::Interval, adapter: :postgresql)
end
