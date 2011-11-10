# encoding: UTF-8

require "helper"

class AssociationsTest < Test::Unit::TestCase

  def setup
    reset_database
  end

  def test_supports_to_one_associations
    yaml = <<-EOF
      Person:
      -
        name: John
        family:
          name: Doe
    EOF
    data = DataMapper::Yamler.make(yaml)

    assert_equal 1, Person.count
    assert_equal 1, Family.count
    assert_equal "John", data["Person"][0].name
    assert_equal "Doe", data["Person"][0].family.name
  end

  def test_supports_to_many_associations
    yaml = <<-EOF
      Family:
      -
        name: Doe
        members:
        -
          name: John
        -
          name: Jane
    EOF
    data = DataMapper::Yamler.make(yaml)

    assert_equal 1, Family.count
    assert_equal 2, Person.count
    assert_equal "Doe", data["Family"][0].name
    assert_equal "John", data["Family"][0].members[0].name
    assert_equal "Jane", data["Family"][0].members[1].name
  end

  def test_supports_nested_associations
    yaml = <<-EOF
      Family:
      -
        name: Doe
        members:
        -
          name: John
          cars:
          -
            name: Herbie
            manufacturer:
              name: VW
          -
            name: KITT
            manufacturer:
              name: Knight Industries
    EOF
    data = DataMapper::Yamler.make(yaml)

    assert_equal 1, Family.count
    assert_equal 1, Person.count
    assert_equal 2, Car.count
    assert_equal "Herbie", Car.first.name
    assert_equal "KITT", Car.last.name
    assert_equal "VW", Company.first.name
    assert_equal "Knight Industries", Company.last.name
    assert_equal "VW", Family.first.members.first.cars.first.manufacturer.name
  end

end
