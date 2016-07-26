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
            ActiveRecord::Base.connected?
          end
        end
      end

      def run
        {
          hostname: Socket.gethostname,
          time: Time.now.utc.to_s,
          ts: Time.now.to_f,
          status: HEALTH_STATUSES[HEALTHY],
          components: NavHealth::Check.run_checks
        }
      end

      def run_checks
        components.checks
      end
    end
  end
end