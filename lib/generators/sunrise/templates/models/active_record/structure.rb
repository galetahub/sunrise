class Structure < ActiveRecord::Base
  include Sunrise::Models::Structure
  include PageParts::Extension
  include MetaManager::Taggable
  include ActiveModel::ForbiddenAttributesProtection

  # audited :protect => false  
  # page_parts :content
end
