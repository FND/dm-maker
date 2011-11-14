# encoding: UTF-8

require "helper"

class ReferencesTest < Test::Unit::TestCase

  def setup
    reset_database
  end

  def test_supports_internal_references
    yaml = <<-EOF
      Family:
      -
        $id: f1
        name: Doe

      Person:
      -
        name: John
        family: { $ref: f1 }
      -
        name: Jane
        family: { $ref: f1 }
    EOF
    data = DataMapper::Maker.make(yaml)

    assert_equal 1, Family.count
    assert_equal 2, Person.count
    assert_equal Person.first.family, Person.last.family
    assert_equal "Doe", Person.first.family.name
  end

end
