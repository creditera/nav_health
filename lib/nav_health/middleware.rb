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

        body = NavHealth::Check.run.to_json

        [status, headers, [body]]
      else
        @app.call env
      end
    end
  end
end