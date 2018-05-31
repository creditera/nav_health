module NavHealth
  class Check
    @components ||= NavHealth::ComponentCollection.new

    class << self
      def config
        yield self
      end

      def components
        @components
      end

      def rails_app= bool
        if bool
          components.add 'db' do
            ActiveRecord::Base.retrieve_connection && ActiveRecord::Base.connected?
          end
        end
      end

      def run
        component_checks = NavHealth::Check.run_checks

        status = HEALTH_STATUSES[HEALTHY]

        # If any components that the app relies on are down, the app should be down
        if component_checks.any? { |check| check[:status] == HEALTH_STATUSES[ERROR] }
          status = HEALTH_STATUSES[ERROR]
        end

        {
          hostname: Socket.gethostname,
          time: Time.now.utc.to_s,
          ts: Time.now.to_f,
          status: status,
          components: component_checks
        }
      end

      def run_checks
        components.checks
      end
    end
  end
end