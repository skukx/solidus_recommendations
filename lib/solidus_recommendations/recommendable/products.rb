module SolidusRecommendations
  module Recommendable
    ##
    # Provides methods to get recommended products based on certain criteria
    # such as "Bought Together" or "Users also bought"
    #
    class Products < Base
      ##
      # Acceptable indices to pass as index option
      # to methods
      #
      ACCEPTED_INDICES = [:user, :order]

      ##
      # Gets recommended products
      #
      # @example Get recommended products based on user index.
      #   product = Spree::Product.find(4)
      #   recommended = SolidusRecommendations::Client.new
      #   recommended.products.get(product)
      #
      #   # Good for getting recommendations based on what other users have
      #   # have purchased.
      #
      # @example Get recommended products based on order index.
      #   product = Spree::Product.find(4)
      #   recommmended = SolidusRecommendations::Client.new
      #   recommended.products.get(product, index: :order)
      #
      #   # Good for getting recommendations based on what others checkout with
      #   # frequently.
      #
      # @param [Spree::Product, Integer] product The product to base recommendations off of.
      # @param [Hash] options
      # @option options [Symbol, String] :index The index to perform aggregation on. (*Defaults to :user*)
      # @option options [Integer] :size The number of recommendations to return. (*Defaults to 10*)
      #
      # @return [Array<Spree::Product]
      #
      def get(product, options = {})
        return [] if product.nil?

        options.deep_symbolize_keys!
        index = options.delete(:index) || :user
        size = options.delete(:size) || 10

        # If index is not supported then we will get a weird undefined
        # method error. This error will make more sense.
        raise Errors::NonSupportedIndex unless ACCEPTED_INDICES.include?(index.to_sym)

        product = convert_to_id([product]).first
        aggs = send("#{index}_index_significant_terms", product, size)

        from_significant_terms(aggs, [product], Spree::Product)
      end

      private

      def order_index_significant_terms(product, size = 10)
        payload = significant_terms_query('product_ids', product, size)
        response = Spree::Order.__elasticsearch__.search(payload)

        response.aggregations.recommended
      end

      def user_index_significant_terms(product, size = 10)
        payload = significant_terms_query('purchased_product_ids', product, size)
        response = Spree.user_class.__elasticsearch__.search(payload)

        response.aggregations.recommended
      end

      ##
      # Builds body for significant terms aggregation.
      #
      def significant_terms_query(field, value, size)
        {
          size: 0,
          query: {
            bool: {
              filter: [
                { term: { "#{field}": value } }
              ]
            }
          },
          aggregations: {
            recommended: {
              significant_terms: {
                field: field,
                size: size + 1
              }
            }
          }
        }
      end
    end
  end
end
