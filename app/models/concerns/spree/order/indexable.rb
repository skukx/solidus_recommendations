# frozen_string_literal: true
module Spree
  class Order
    module Indexable
      extend ActiveSupport::Concern

      ELASTICSEARCH_SETTINGS = {
        analysis: {
          analyzer: {
            keyword_lowercase: {
              tokenizer: 'keyword',
              filter: ['lowercase']
            }
          }
        }
      }

      included do
        include Spree::Indexable

        ##
        # Define Order mapping for Elasticserach index
        #
        settings ELASTICSEARCH_SETTINGS do
          mappings dynamic: false do
            indexes :product_ids, type: 'integer'
            indexes :created_at, type: 'date'
            indexes :completed_at, type: 'date'
          end
        end

        ##
        # Formats hash for elasticsearch.
        #
        def as_indexed_json(_options = {})
          as_json only: [:created_at, :completed_at],
                  methods: [:product_ids]
        end
      end
    end
  end
end
