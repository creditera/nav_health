require 'test_helper'

class TestMiddleware < MiniTest::Test
  def test_exists
    assert defined?(NavHealth::Middleware)
  end

  def test_calls_app_if_no_match
    body = [200, {}, [{foo: 'bar'}.to_json]]
    env = { 'REQUEST_PATH' => '/foo' }
    app = -> (env) { body }

    middleware = NavHealth::Middleware.new app

    result = middleware.call env

    assert_equal body, result
  end

  def test_returns_health_check_if_match
    body = [200, {}, [{foo: 'bar'}.to_json]]
    env = { 'REQUEST_PATH' => '/nav_health' }
    app = -> (env) { body }

    middleware = NavHealth::Middleware.new app

    result = middleware.call env

    refute_equal body, result
  end
end