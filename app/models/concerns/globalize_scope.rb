# frozen_string_literal: true

module GlobalizeScope
  extend ActiveSupport::Concern

  module ClassMethods
    def with_translations(*locales)
      locales = translated_locales if locales.empty?
      table = arel_table
      translation_table = translation_class.arel_table
      join = table.join(translation_table, Arel::Nodes::OuterJoin)
                  .on(table[:id]
                         .eq(translation_table[translation_options[:foreign_key].to_sym])
                         .and(translation_table[:locale].in(locales.flatten.map(&:to_s))))
                  .join_sources
      joins(join).readonly(false)
    end
  end
end
