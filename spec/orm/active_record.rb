# frozen_string_literal: true

# Run any available migration
require 'active_record'

def run_db_migrations(migrate_path)
  ActiveRecord::MigrationContext.new(migrate_path).migrate
end

run_db_migrations File.expand_path('../dummy/db/migrate', __dir__)
run_db_migrations File.expand_path('../../db/migrate', __dir__)
