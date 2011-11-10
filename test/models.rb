# encoding: UTF-8

class Person
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :age, Integer

  belongs_to :family, :required => false
  has n, :cars

end

class Family
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :members, "Person"

end

class Car
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  belongs_to :manufacturer, "Company"

end

class Company
  include DataMapper::Resource

  property :id, Serial
  property :name, String

end
