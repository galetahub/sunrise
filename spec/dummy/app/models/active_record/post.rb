# frozen_string_literal: true

class Post < ActiveRecord::Base
  include PublicActivity::Model

  tracked owner: ->(controller, _model) { controller.try(:current_user) }

  belongs_to :structure

  delegate :title, :parent_id, :slug, to: :structure, prefix: true

  def self.sunrise_search(params)
    query = all

    query = query.where(title: params[:title]) if params[:title].present?
    query = query.where(structure_id: params[:structure_id]) if params[:structure_id].present?

    query
  end
end
