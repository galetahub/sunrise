module Sunrise
  module Hooks
    module Adapters
      module ActiveRecord
        def where_like(column, value)
          where(["#{quoted_table_name}.#{column} LIKE ?", "#{value}%"])
        end
      end
    end
  end
end