# frozen_string_literal: true

module Sunrise
  module Utils
    # Russian transliteration
    #
    module Transliteration
      extend self

      # Transliteration heavily based on rutils gem by Julian "julik" Tarkhanov and Co.
      # <http://rutils.rubyforge.org/>
      # Cleaned up and optimized.

      LOWER_SINGLE = {
        'і' => 'i', 'ґ' => 'g', 'ё' => 'yo', '№' => '#', 'є' => 'e',
        'ї' => 'yi', 'а' => 'a', 'б' => 'b',
        'в' => 'v', 'г' => 'g', 'д' => 'd', 'е' => 'e', 'ж' => 'zh',
        'з' => 'z', 'и' => 'i', 'й' => 'y', 'к' => 'k', 'л' => 'l',
        'м' => 'm', 'н' => 'n', 'о' => 'o', 'п' => 'p', 'р' => 'r',
        'с' => 's', 'т' => 't', 'у' => 'u', 'ф' => 'f', 'х' => 'h',
        'ц' => 'ts', 'ч' => 'ch', 'ш' => 'sh', 'щ' => 'sch', 'ъ' => "'",
        'ы' => 'y', 'ь' => '', 'э' => 'e', 'ю' => 'yu', 'я' => 'ya'
      }.freeze
      LOWER_MULTI = {
        'ье' => 'ie',
        'ьё' => 'ie'
      }.freeze

      UPPER_SINGLE = {
        'Ґ' => 'G', 'Ё' => 'YO', 'Є' => 'E', 'Ї' => 'YI', 'І' => 'I',
        'А' => 'A', 'Б' => 'B', 'В' => 'V', 'Г' => 'G',
        'Д' => 'D', 'Е' => 'E', 'Ж' => 'ZH', 'З' => 'Z', 'И' => 'I',
        'Й' => 'Y', 'К' => 'K', 'Л' => 'L', 'М' => 'M', 'Н' => 'N',
        'О' => 'O', 'П' => 'P', 'Р' => 'R', 'С' => 'S', 'Т' => 'T',
        'У' => 'U', 'Ф' => 'F', 'Х' => 'H', 'Ц' => 'TS', 'Ч' => 'CH',
        'Ш' => 'SH', 'Щ' => 'SCH', 'Ъ' => "'", 'Ы' => 'Y', 'Ь' => '',
        'Э' => 'E', 'Ю' => 'YU', 'Я' => 'YA'
      }.freeze
      UPPER_MULTI = {
        'ЬЕ' => 'IE',
        'ЬЁ' => 'IE'
      }.freeze

      LOWER = LOWER_SINGLE.merge(LOWER_MULTI).freeze
      UPPER = UPPER_SINGLE.merge(UPPER_MULTI).freeze
      MULTI_KEYS = LOWER_MULTI.merge(UPPER_MULTI).keys.sort_by { |s| s.length }.reverse.freeze

      # Transliterate a string with russian characters
      #
      # Возвращает строку, в которой все буквы русского алфавита заменены на похожую по звучанию латиницу
      def transliterate(str)
        chars = str.scan(/#{MULTI_KEYS.join '|'}|\w|./)

        result = ''

        chars.each_with_index do |char, index|
          result << if UPPER.key?(char) && LOWER.key?(chars[index + 1])
                      # combined case
                      UPPER[char].downcase.capitalize
                    elsif UPPER.key?(char)
                      UPPER[char]
                    elsif LOWER.key?(char)
                      LOWER[char]
                    else
                      char
                    end
        end

        result
      end
    end
  end
end
