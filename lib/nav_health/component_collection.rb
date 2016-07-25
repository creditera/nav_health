module NavHealth
  class ComponentCollection
    attr_accessor :components

    def initialize components = nil
      components ||= {}

      self.components = components
    end

    def add name, &block
      components[name] = block.to_proc
    end

    def checks
      components.map do |name, proc|
        status = HEALTH_STATUSES[HEALTHY]

        begin
          unless proc.call
            status = HEALTH_STATUSES[ERROR]
          end
        rescue
          status = HEALTH_STATUSES[ERROR]
        end

        {
          name: name,
          status: status
        }
      end
    end
  end
end