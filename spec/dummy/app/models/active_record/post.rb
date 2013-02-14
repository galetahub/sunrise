class Post < ActiveRecord::Base
  include PublicActivity::Model
  tracked
  
  belongs_to :structure
  
  delegate :title, :parent_id, :slug, :to => :structure, :prefix => true
  
  def self.sunrise_search(params)
    query = scoped
    
    query = query.where(:title => params[:title]) unless params[:title].blank?
    query = query.where(:structure_id => params[:structure_id]) unless params[:structure_id].blank?
    
    query
  end
end
