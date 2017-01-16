module Spree
  class User
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
            indexes :purchased_product_ids, type: 'integer'
            indexes :created_at, type: 'date'
          end
        end

        ##
        # Formats hash for elasticsearch.
        #
        def as_indexed_json(_options = {})
          as_json methods: [:purchased_product_ids]
        end

        private

        def purchased_product_ids
          orders.map(&:product_ids).flatten.uniq
        end
      end
    end
  end
end
