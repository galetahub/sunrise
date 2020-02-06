# frozen_string_literal: true

# Run any available migration
require 'active_record'

ActiveRecord::Migrator.migrate File.expand_path('../dummy/db/migrate', __dir__)
ActiveRecord::Migrator.migrate File.expand_path('../../db/migrate', __dir__)
