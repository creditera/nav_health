require 'json'
require 'socket'

module NavHealth
  class Middleware
    HEALTH_CHECK_PATH = '/nav_health'

    def initialize app
      @app = app
    end
    
    def call env
      if env['REQUEST_PATH'] == HEALTH_CHECK_PATH
        status = 200

        headers = {
          'Content-Type' => 'application/json'
        }

        body = NavHealth::Check.run

        status = 500 if body[:status] == HEALTH_STATUSES[ERROR]

        [status, headers, [body.to_json]]
      else
        @app.call env
      end
    end
  end
end