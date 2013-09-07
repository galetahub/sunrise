require 'rails-uploader'

class Asset
  include Mongoid::Document
  include Mongoid::Timestamps
  include Uploader::Asset
  
  include Sunrise::CarrierWave::Glue
  include Sunrise::Models::Asset
  
  # Columns
  field :data_file_name, :type => String
  field :data_content_type, :type => String
  field :data_file_size, :type => Integer
  field :width, :type => Integer
  field :height, :type => Integer
  field :guid, :type => String
  field :sort_order, :type => Integer, :default => 0
  field :width, :type => Integer
  field :height, :type => Integer
        
  index({:guid => 1})
  index({:user_id => 1})
  index({:assetable_type => 1, :assetable_id => 1, :type => 1})

  # Validations
  validates_presence_of :data
  
  default_scope asc(:sort_order)
end
