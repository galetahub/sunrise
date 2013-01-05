# Run any available migration
require 'active_record'

ActiveRecord::Migrator.migrate File.expand_path("../../dummy/db/migrate/", __FILE__)
ActiveRecord::Migrator.migrate File.expand_path("../../../db/migrate/", __FILE__)

require "audited-activerecord"
Audited.audit_class = Audited::Adapters::ActiveRecord::Audit
