# NavHealth

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nav_health'
```

And then execute:
```
 $ bundle
```
Or install it yourself as:
```
 $ gem install nav_health
```
## Usage

To quickly enable health checks in your service, add the gem as instructed above, and include the middleware in your Rack app.

```ruby
use NavHealth::Middleware
```

For Rails apps:

```ruby
class Application < Rails::Application
  config.middleware.use NavHealth::Middleware
end
```

This will create an endpoint at `<YOUR_APP_URL>/nav_health` that returns a JSON with this format:

```json
{
  "hostname": "<YOUR_HOSTNAME>",
  "time": "2016-07-25T20:40:41.935Z",
  "ts": "1469461896.3307981",
  "status": "allgood",
  "components": [
    //...components
  ]
}
```