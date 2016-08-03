# NavHealth

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nav_health', git: 'https://github.com/creditera/nav_health.git'
```

And then execute:
```
 $ bundle
```
## Usage

To quickly enable health checks in your service, add the gem as instructed above, and include the middleware in your Rack app.

```ruby
use NavHealth::Middleware
```

For Rails apps:

```ruby
class Application < Rails::Application
  NavHealth::Check.config do |health|
    health.rails_app = true
  end

  config.middleware.use NavHealth::Middleware
end
```

This will create an endpoint at `<YOUR_APP_URL>/nav_health` that returns a JSON in this format:

```json
{
  "hostname": "<YOUR_HOSTNAME>",
  "time": "2016-07-25T20:40:41.935Z",
  "ts": "1469461896.3307981",
  "status": "allgood",
  "components": []
}
```

For Rails applications, setting the config option will automatically inject a `:db` component check that will verify that your app can talk to its database.

## Configuring the Check

Initially, the health check will return a basic response, detailed above. If your service depends on the accessibility or uptime of related components, you'll want to add smaller checks for those.

Adding a component to the health check is straightforward. You just need to add a component with a name and a block to the `NavHealth::Check.config` step:

```ruby
NavHealth::Check.config do |health|
  health.components.add 'db' do
    # Add logic to determine if the database connection is functioning...
  end
end
```

Component names must be unique, but there are no limits to the number of components your app can expose.

Component checks return a simplified response in the components portion of the health check.

```json
{
  //...
  "components": [
    {
      "name": "db",
      "status": "allgood"
    }
  ]
}
```

A component will be marked as unhealthy if it returns a false-y value from the defined block, or if execution of the block raises an exception.

IMPORTANT NOTE: If ANY ONE of the specified components returns an error response, your entire service will be marked as unhealthy. Be sure that the components you define in this way are absolutely required for your service to function properly.
