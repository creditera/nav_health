require 'json'
require 'socket'

module NavHealth
  class Middleware
    HEALTH_CHECK_PATH = '/nav_health'

    @components ||= NavHealth::ComponentCollection.new

    class << self
      def config
        yield self
      end

      def components
        @components
      end
    end

    def initialize app
      @app = app
    end
    
    def call env
      if env['REQUEST_PATH'] == HEALTH_CHECK_PATH
        status = 200

        headers = {
          'Content-Type' => 'application/json'
        }

        body = {
          hostname: Socket.gethostname,
          time: Time.now.utc.to_s,
          ts: Time.now.to_f,
          status: HEALTH_STATUSES[HEALTHY],
          components: self.class.instance_variable_get('@components').checks
        }.to_json

        [status, headers, [body]]
      else
        @app.call env
      end
    end
  end
end