if Object.const_defined?("Mongoid")
  class Post
    include Mongoid::Document
    include Mongoid::Timestamps
    include PublicActivity::Model
    
    # Columns
    field :title, :type => String
    field :content, :type => String
    field :is_visible, :type => Boolean

    belongs_to :structure, :index => true
    
    delegate :title, :parent_id, :slug, :to => :structure, :prefix => true

    tracked owner: ->(controller, model) { controller.try(:current_user) }
    
    def self.sunrise_search(params)
      query = scoped
      
      query = query.where(:title => params[:title]) unless params[:title].blank?
      query = query.where(:structure_id => params[:structure_id]) unless params[:structure_id].blank?
      
      query
    end
  end
end