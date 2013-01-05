require 'mongoid'
require "database_cleaner"

DatabaseCleaner[:mongoid].strategy = :truncation
