module ExtRails
  @@config = nil

  def self.configure
    @@config ||= Configuration.new

    if block_given?
      yield config
    end

    config
  end

  def self.config
    @@config || configure
  end

  class Configuration
    attr_accessor :skip_migrations
    attr_accessor :i18n_debug
    attr_accessor :query_debug
    attr_writer :html_extra_tags
    attr_writer :profile
    attr_writer :rescue_500
    attr_writer :version
    attr_writer :skip_locking

    def html_extra_tags
      @html_extra_tags ||= []
    end

    def profile
      return @profile if defined? @profile

      @profile ||= '(app|lib)/'
    end

    def rescue_500?
      defined?(@rescue_500) ? @rescue_500 : !(Rails.env.development? || Rails.env.test?)
    end

    def version
      @version ||= Rails.root.join('REVISION').exist? ? Rails.root.join('REVISION').read.first(7) : '0.1.0'
    end

    def skip_locking(*fields)
      if block_given?
        @skip_locking ||= ['id']
        skip_locking_was = @skip_locking
        @skip_locking += fields
        yield
        @skip_locking = skip_locking_was
      else
        @skip_locking ||= ['id'] # updated_at
      end
    end
  end
end
