# frozen_string_literal: true

module ApplicationHelper
  def structure_path(record)
    return if record.nil?

    case record.structure_type
    when StructureType.page then record.slug
    when StructureType.main then root_path
    when StructureType.redirect then record.redirect_url
    when StructureType.group then '#'
    end
  end
end
