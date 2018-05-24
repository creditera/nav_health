require 'json'
require 'socket'

module NavHealth
  class Middleware
    HEALTH_CHECK_PATH = '/nav_health'

    def initialize app
      @app = app
    end

    def call env
      path = env['REQUEST_PATH'] || env['PATH_INFO']
      if path == HEALTH_CHECK_PATH
        status = 200

        headers = {
          'Content-Type' => 'application/json'
        }

        body = NavHealth::Check.run

        if body[:status] == HEALTH_STATUSES[ERROR]
          status = 500
          defined?(::Rails) and ::Rails.logger.info(body.to_json)
        end

        [status, headers, [body.to_json]]
      else
        @app.call env
      end
    end
  end
end
