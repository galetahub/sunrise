# frozen_string_literal: true

require 'active_support/inflector/inflections'

class String
  def parameterize(sep = '-')
    value = Sunrise::Utils::Transliteration.transliterate(self)
    ActiveSupport::Inflector.parameterize(value, sep)
  end

  def self.randomize(length = 8)
    Array.new(length) { (rand(122 - 97) + 97).chr }.join
  end
end
