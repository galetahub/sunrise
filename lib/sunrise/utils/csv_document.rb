require 'csv'

module Sunrise
  module Utils
    class CsvDocument
      def initialize(source, options = {})
        @source = source
        @options = options
        @klass = (@options.delete(:klass) || extract_klass)
      end
      
      def columns_names
        @columns_names ||= (@options[:columns] || @klass.column_names)
      end
      
      def human_columns_names
        @human_columns_names ||= columns_names.map { |column| @klass.human_attribute_name(column.to_s) }
      end
      
      def filename
        @filename ||= [(@options[:filename] || @klass.model_name.plural || "document"), ".csv"].join
      end
      
      def render
        csv_string = ::CSV.generate do |csv|
          csv << human_columns_names
          
          each_with_index do |record, index|
            row = columns_names.inject([]) do |result, column|
              result << record.send(column)
              result
            end
            
            csv << row
          end
        end
      end
      
      def each_with_index
        count = 0
        
        if @source.respond_to?(:find_each)
          @source.find_each do |item|
            yield item, count
            count += 1
          end
        else
          Array.wrap(@source).each do |item|
            yield item, count
            count += 1
          end
        end
      end
      
      protected
      
        def extract_klass
          if @source.respond_to?(:klass)
            @source.klass 
          elsif @source.is_a?(Array)
            @source.first.try(:class)
          else
            @source.class
          end
        end
      
    end
  end
end
