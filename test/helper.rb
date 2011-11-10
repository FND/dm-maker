# encoding: UTF-8

require "dm-core"
require "dm-transactions"
require "dm-migrations"
require "test/unit"

require "models"
require "dm-yamler"

DataMapper.setup(:default, "sqlite::memory:")
DataMapper.finalize
DataMapper.auto_migrate!
DataMapper::Model.raise_on_save_failure = true

def reset_database
  models = DataMapper::Model.descendants
  models.first.transaction do
    models.each(&:destroy!)
  end
end
