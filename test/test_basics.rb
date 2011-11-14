# encoding: UTF-8

require "helper"

class BasicsTest < Test::Unit::TestCase

  def setup
    reset_database
  end

  def test_accepts_yaml
    yaml = <<-EOF
      Person:
      -
        name: John Doe
        age: 11
      -
        name: Jane Doe
        age: 13
    EOF
    DataMapper::Maker.make(yaml)

    assert_equal 2, Person.count
    assert_equal "John Doe", Person.first.name
    assert_equal 11, Person.first.age
    assert_equal "Jane Doe", Person.last.name
    assert_equal 13, Person.last.age
  end

  def test_accepts_plain_objects
    DataMapper::Maker.make({
      "Person" => [
        {
          "name" => "John Doe",
          :age => 11
        }, {
          :name => "Jane Doe",
          :age => 13
        }
      ]
    })

    assert_equal 2, Person.count
    assert_equal "John Doe", Person.first.name
    assert_equal 11, Person.first.age
    assert_equal "Jane Doe", Person.last.name
    assert_equal 13, Person.last.age
  end

  def test_returns_instances
    yaml = <<-EOF
      Person:
      -
        name: John
        age: 11
      -
        name: Jane
        age: 13

      Family:
      -
        name: Doe
    EOF
    data = DataMapper::Maker.make(yaml)

    assert_equal 2, data.length
    assert_equal 2, data["Person"].length
    assert_equal "John", data["Person"][0].name
    assert_equal 11, data["Person"][0].age
    assert_equal "Jane", data["Person"][1].name
    assert_equal 13, data["Person"][1].age
    assert_equal 1, data["Family"].length
    assert_equal "Doe", data["Family"][0].name
  end

  def test_supports_ERB_expansion
    yaml = <<-EOF
      Person:
      <% 2.times do |i| %>
      -
        name: Johnny <%= i + 5 %>
        age: <%= i %>
      <% end %>
    EOF

    data = DataMapper::Maker.make(yaml)
    assert_equal 2, data["Person"].length
    assert_equal "Johnny 5", data["Person"].first.name
    assert_equal 0, data["Person"].first.age
    assert_equal "Johnny 6", data["Person"].last.name
    assert_equal 1, data["Person"].last.age
  end

end
