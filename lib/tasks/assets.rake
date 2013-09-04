require 'progressbar'

namespace :assets do
  desc "Refresh carrierwave assets versions by model (CLASS=)"
  task :reprocess => :environment do
    name = (ENV['CLASS'] || ENV['class'] || 'Asset').to_s
    klass = name.safe_constantize
    
    raise "Cannot find a constant with the #{name} specified in the argument string" if klass.nil?
    
    pbar = ProgressBar.new(name, klass.count)
    pbar.bar_mark = "="
    
    index = 0
    
    reprocess = ->(item) { 
      item.data.recreate_versions!
      index += 1
      pbar.set(index)
    }
    
    if defined?(Mongoid::Document) && klass.ancestors.include?(Mongoid::Document)
      klass.all.each &reprocess
    else
      klass.find_each &reprocess
    end
    
    pbar.finish
  end
end
