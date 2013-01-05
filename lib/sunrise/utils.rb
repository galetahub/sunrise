module Sunrise
  module Utils
    autoload :Transliteration, 'sunrise/utils/transliteration'
    autoload :Mysql, 'sunrise/utils/mysql'
    autoload :EvalHelpers, 'sunrise/utils/eval_helpers'
    autoload :CsvDocument, 'sunrise/utils/csv_document'
    autoload :SearchWrapper, 'sunrise/utils/search_wrapper'
    
    IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg', 'image/tiff', 'image/x-png']
    
    def self.get_model(model_name, *args)
      klass = lookup(["Sunrise", model_name.to_s.classify].join, Sunrise::AbstractModel)
      klass ? klass.new(*args) : nil
    end
  
    # Given a string +model_name+, finds the corresponding model class
    def self.lookup(model_name, klass = nil)
      model = model_name.constantize rescue nil

      if model && model.is_a?(Class)
        model
      else
        nil
      end
    rescue LoadError
      Sunrise::Engine.logger.error "Error while loading '#{model_name}': #{$!}"
      nil
    end
    
    def self.superclasses(klass)
      superclasses = []
      while klass
        superclasses << klass.superclass if klass && klass.superclass
        klass = klass.superclass
      end
      superclasses
    end
    
    # Convert sort string to hash
    # "create_at_desc" to { :column => "created_at", :mode => "desc" }
    #
    def self.sort_to_hash(value)
      items = value.split('_')
      mode = items.pop
      column = items.join('_')
      
      {:column => column, :mode => mode}
    end

    # Convert input to friendly slug using babosa gem
    #
    def self.normalize_friendly_id(input)
      input.to_s.to_slug.normalize(:transliterations => Sunrise::Config.transliteration).to_s
    end
  end
end
