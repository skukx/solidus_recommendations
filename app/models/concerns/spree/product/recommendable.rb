module Spree
  class Product
    module Recommendable
      extend ActiveSupport::Concern

      class_methods do
        ##
        # Get recommendations for products.
        # @return [Recommendations::Recommendable::Products]
        #
        def recommendations
          @recommend_client ||= SolidusRecommendations::Client.new
          @recommend_client.products
        end
      end
    end
  end
end
