class Post < ActiveRecord::Base
  belongs_to :structure
  
  def self.sunrise_search(params)
    query = scoped
    
    query = query.where(:title => params[:title]) unless params[:title].blank?
    query = query.where(:structure_id => params[:structure_id]) unless params[:structure_id].blank?
    
    query
  end
end
