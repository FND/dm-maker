# encoding: UTF-8

require "helper"

class ErrorsTest < Test::Unit::TestCase

  def setup
    reset_database
    @raise_setting = DataMapper::Model.raise_on_save_failure

    @yaml = <<-EOF
      Person:
      -
        name: John Doe
        age: 11
      -
        age: 17
      -
        name: Jane Doe
        age: 13
    EOF
  end

  def teardown
    DataMapper::Model.raise_on_save_failure = @raise_setting
  end

  def test_reports_silent_errors
    DataMapper::Model.raise_on_save_failure = false

    data = DataMapper::Maker.make(@yaml)

    assert_equal 2, Person.count
    assert_equal "John Doe", Person.first.name
    assert_equal "Jane Doe", Person.last.name

    assert_equal 1, data["_errors"].length
    assert_equal "Person", data["_errors"].first.class.name
    assert (not data["_errors"].first.saved?)
  end

  def test_does_not_swallow_exceptions
    DataMapper::Model.raise_on_save_failure = true

    assert_raise DataMapper::SaveFailureError do
      data = DataMapper::Maker.make(@yaml)
    end
    assert_equal 1, Person.count
    assert_equal "John Doe", Person.first.name
    # Jane Doe was never processed
  end

end
