module Sunrise
  module Utils
    autoload :Header, 'sunrise/utils/header'
    autoload :Transliteration, 'sunrise/utils/transliteration'
    autoload :I18nBackend, 'sunrise/utils/i18n_backend'
    autoload :Mysql, 'sunrise/utils/mysql'
    
    IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg', 'image/tiff', 'image/x-png']
    
    def self.get_model(model_name)
      klass = ["Sunrise", model_name.to_s.classify].join.constantize
      klass.new
    end
  
    # Given a string +model_name+, finds the corresponding model class
    def self.lookup(model_name)
      model = model_name.constantize rescue nil
      if model && model.is_a?(Class) && superclasses(model).include?(ActiveRecord::Base) && !model.abstract_class?
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
    
  end
end
