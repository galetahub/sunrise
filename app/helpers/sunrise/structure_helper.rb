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

    def show_model_path(abstract_model, record)
      model_name = abstract_model.plural

      case model_name
      when :some_collection then index_path(:model_name => :stores, :parent_type => :some_collection, :parent_id => record.id)
      else show_path(:id => record.id)
      end
    end
  end
end
