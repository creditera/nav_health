require 'test_helper'

class TestComponentCollection < MiniTest::Test
  def test_exists
    assert defined?(NavHealth::ComponentCollection)
  end

  def test_can_add_component
    collection = NavHealth::ComponentCollection.new

    collection.add 'db' do
      true
    end

    assert_equal false, collection.components.empty?
  end

  def test_checks
    collection = NavHealth::ComponentCollection.new

    collection.add 'db' do
      true
    end

    result = collection.checks

    expected_body = [
      {
        name: 'db',
        status: 'allgood'
      }
    ]

    assert_equal expected_body, result
  end

  def test_checks_return_false
    collection = NavHealth::ComponentCollection.new

    collection.add 'db' do
      false
    end

    result = collection.checks

    expected_body = [
      {
        name: 'db',
        status: 'sonofa'
      }
    ]

    assert_equal expected_body, result
  end
end