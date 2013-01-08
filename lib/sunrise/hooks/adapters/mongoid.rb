module Sunrise
  module Hooks
    module Adapters
      module Mongoid
        def order(*args)
          order_by(*args)
        end

        def select(*args)
          only(*args)
        end

        def find_each(*args)
          each do |record|
            yield record
          end
        end

        def where_like(column, value)
          where(column => value)
        end
      end
    end
  end
end