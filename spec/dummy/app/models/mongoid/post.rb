# frozen_string_literal: true

if Object.const_defined?('Mongoid')
  class Post
    include Mongoid::Document
    include Mongoid::Timestamps
    include PublicActivity::Model

    # Columns
    field :title, type: String
    field :content, type: String
    field :is_visible, type: Boolean

    belongs_to :structure, index: true

    delegate :title, :parent_id, :slug, to: :structure, prefix: true

    tracked owner: ->(controller, _model) { controller.try(:current_user) }

    def self.sunrise_search(params)
      query = all

      query = query.where(title: params[:title]) if params[:title].present?
      query = query.where(structure_id: params[:structure_id]) if params[:structure_id].present?

      query
    end
  end
end
