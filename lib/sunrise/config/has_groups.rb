require 'sunrise/config/group'

module Sunrise
  module Config
    module HasGroups
      # Accessor for a group
      #
      # If group with given name does not yet exist it will be created. If a
      # block is passed it will be evaluated in the context of the group
      def group(name, &block)
        groups[name] ||= Sunrise::Config::Group.new(abstract_model, self, name)
        groups[name].instance_eval &block if block
        groups[name]
      end

      # Reader for groups
      def groups
        @groups ||= {}
      end

      # Reader for groups that are marked as visible
      def visible_groups
        groups.select {|g| g.visible? }
      end
    end
  end
end 
