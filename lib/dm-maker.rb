# encoding: UTF-8

require "yaml"
require "erb"
require "active_support"
require "active_support/core_ext"
require "active_support/inflector"

require "dm-maker/version"

module DataMapper
  module Maker

    REL_TYPES = {
      :to_one => [DataMapper::Associations::ManyToOne::Relationship,
          DataMapper::Associations::OneToOne::Relationship],
      :to_many => [DataMapper::Associations::ManyToMany::Relationship,
          DataMapper::Associations::OneToMany::Relationship]
    }

    def self.make(data)
      data = load_yaml(data) if data.class == String

      cache = {}
      return data.each_with_object({}) do |(class_name, instances), hsh|
        klass = class_name.constantize
        hsh[class_name] = instances.map { |instance_data|
          create_instance(klass, instance_data, cache)
        }
      end
    end

    def self.create_instance(klass, data, cache={}) # TODO: document $id / $ref
      if ref = data.delete("$ref")
        raise ArgumentError if data.length > 0
        return cache[ref]
      end
      id = data.delete("$id")

      data.each { |key, value|
        rel_name = key.to_sym
        if rel = klass.relationships[rel_name]
          if REL_TYPES[:to_many].include? rel.class
            assoc_class = klass.new. # XXX: hacky
                send(rel_name).relationship.child_model
            value = value.map { |d|
              if custom_class = d.delete("$class") # TODO: document and test
                assoc_class = custom_class.constantize
              end
              create_instance(assoc_class, d, cache)
            }
          elsif REL_TYPES[:to_one].include? rel.class
            if custom_class = d.delete("$class") # TODO: document and test
              assoc_class = custom_class.constantize
            else
              assoc_class = (rel.child_model == klass or klass < rel.child_model) ?
                  rel.parent_model : rel.child_model
            end
            value = create_instance(assoc_class, value, cache)
          end
        end
        data[key] = value # XXX: dangerous while iterating over that same hash!?
      }

      instance = klass.new(data)
      begin
        instance.save
      rescue DataMapper::SaveFailureError
        # rely on parent saving -- FIXME: hacky!?
      end

      cache[id] = instance if id
      return instance
    end

    def self.load_yaml(yaml)
      yaml = ERB.new(yaml).result # TODO: document
      # hack to retain order in Ruby 1.8
      # TODO: document expectations/constraints (only required for $id / $ref)
      yaml.split("\n\n").each_with_object(ActiveSupport::OrderedHash.new) { |yml, hsh|
        hsh.merge! YAML.load(yml)
      }
    end

  end
end
