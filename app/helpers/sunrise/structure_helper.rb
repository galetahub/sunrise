module Sunrise
  module StructureHelper
    def manage_structure_path(record, options = {})
      return "#" if record.nil?
      options = {:parent_id => record.id, :parent_type => 'Structure'}.merge(options)
      
      case record.structure_type.kind
      when :page then edit_path(:model_name => "pages", :id => record.id)
      when :posts then index_path(options.merge({:model_name => record.structure_type.kind}))
      else edit_path(:model_name => "structures", :id => record.id)
      end
    end
  end
end
