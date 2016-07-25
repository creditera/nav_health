require "nav_health/version"
require 'nav_health/component_collection'
require 'nav_health/middleware'

module NavHealth
  HEALTH_STATUSES = %w(allgood ruhroh sonofa)
  HEALTHY = 0
  WARNING = 1
  ERROR = 2
end
