# encoding: utf-8
require 'pathname'
require 'sunrise/core_ext'
require 'sunrise/version'

module Sunrise
  autoload :Utils, 'sunrise/utils'
  autoload :Config, 'sunrise/config'
  autoload :AbstractModel, 'sunrise/abstract_model'
  
  module Models
    autoload :Asset, 'sunrise/models/asset'
    autoload :Page, 'sunrise/models/page'
    autoload :Structure, 'sunrise/models/structure'
    autoload :StructureType, 'sunrise/models/structure_type'
    autoload :PositionType, 'sunrise/models/position_type'
    autoload :Role, 'sunrise/models/role'
    autoload :RoleType, 'sunrise/models/role_type'
    autoload :Header, 'sunrise/models/header'
    autoload :User, 'sunrise/models/user'
    autoload :Ability, 'sunrise/models/ability'
  end
  
  module CarrierWave
    autoload :Glue, 'sunrise/carrier_wave/glue'
    autoload :BaseUploader, 'sunrise/carrier_wave/base_uploader'
    autoload :FileSizeValidator, 'sunrise/carrier_wave/file_size_validator'
  end
  
  module NestedSet
    autoload :Descendants, 'sunrise/nested_set/descendants'
    autoload :Depth, 'sunrise/nested_set/depth'
  end
  
  module Views
    autoload :FormBuilder, 'sunrise/views/form_builder'
  end
  
  module Hooks
    autoload :Kaminari, 'sunrise/hooks/kaminari'
  end
  
  def self.root_path
    @root_path ||= Pathname.new( File.dirname(File.expand_path('../', __FILE__)) )
  end
  
  def self.setup
    yield Config
  end
end

require 'sunrise/engine'
