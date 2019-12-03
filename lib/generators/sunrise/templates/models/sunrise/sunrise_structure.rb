# encoding: utf-8
class SunriseStructure < Sunrise::AbstractModel
  self.resource_name = "Structure"

  default_index_view :tree
  available_index_views [:tree, :thumbs]

  index :tree do
    field :title
    field :updated_at
    field :id
  end

  show do
    field :title
    field :redirect_url
    field :is_visible
  end

  form do
    field :title
    field :redirect_url
    field :slug
    field :parent_id, collection: lambda { Structure.nested_set_options() {|i| "#{'–' * i.depth} #{i.title}"} }, if: lambda { |s| s.moveable? }
    field :structure_type_id, collection: lambda { StructureType.all }, include_blank: false
    field :position_type_id, collection: lambda { PositionType.all }, include_blank: false
    field :is_visible

    group :meta_tags, holder: :sidebar do
      field :tag_title
      field :tag_keywords
      field :tag_description
    end
  end
end
