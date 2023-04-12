# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern
  included do
    def self.search(query, searchable_terms, combination_operator = 'OR')
      search_query =
        generate_search_query(searchable_terms, combination_operator)
      where(search_query, query: "%#{query}%")
    end

    def self.generate_search_query(searchable_terms, combination_operator)
      searchable_terms.reduce('') do |accum, searchable_term|
        seperating_term = accum == '' ? '' : combination_operator
        "#{accum} #{seperating_term} #{searchable_term} LIKE :query"
      end
    end
  end
end
