require 'test_helper'

class TestCheck < MiniTest::Test
  def test_exists
    assert defined?(NavHealth::Check)
  end

  def test_config
    NavHealth::Check.config do |middleware|
      middleware.components.add 'db' do
        true
      end
    end

    collection = NavHealth::Check.instance_variable_get('@components')

    refute_equal true, collection.components.empty?
  end

  def test_config_for_rails_app
    NavHealth::Check.config do |middleware|
      middleware.rails_app = true
    end

    collection = NavHealth::Check.instance_variable_get('@components')

    refute_equal true, collection.components.empty?
  end

  def test_run
    NavHealth::Check.config do |middleware|
      middleware.components.add 'db' do
        true
      end
    end

    result = NavHealth::Check.run

    expected_keys = [:hostname, :time, :ts, :status, :components]

    assert_equal result.keys, expected_keys
  end

  def test_run_with_component_errors
    # The service should show as down if a dependent service is unreachable
    NavHealth::Check.config do |middleware|
      middleware.components.add 'db' do
        false
      end
    end

    result = NavHealth::Check.run

    assert_equal 'sonofa', result[:status]
  end

  def test_run_with_activerecord
    require "active_record"
    NavHealth::Check.config do |middleware|
      middleware.rails_app = true
    end
    ActiveRecord::Base.establish_connection(
      adapter:  "sqlite3",
      database: "tmp/test_db.sqlite3"
    )

    assert_equal false, ActiveRecord::Base.connected?
    result = NavHealth::Check.run
    assert_equal "allgood", result[:status]
    ActiveRecord::Base.remove_connection
  end

  def test_run_with_activerecord_not_connected
    require "active_record"
    NavHealth::Check.config do |middleware|
      middleware.rails_app = true
    end

    assert_equal false, !!ActiveRecord::Base.connected?
    result = NavHealth::Check.run
    assert_equal "sonofa", result[:status]
    ActiveRecord::Base.remove_connection
  end

  def test_run_with_activerecord_connected
    require "active_record"
    NavHealth::Check.config do |middleware|
      middleware.rails_app = true
    end
    ActiveRecord::Base.establish_connection(
      adapter:  "sqlite3",
      database: "tmp/test_db.sqlite3"
    )
    ActiveRecord::Base.retrieve_connection

    assert_equal true, ActiveRecord::Base.connected?
    result = NavHealth::Check.run
    assert_equal "allgood", result[:status]
    ActiveRecord::Base.remove_connection
  end
end
