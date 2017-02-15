# frozen_string_literal: true
module SolidusRecommendations
  class Client
    ##
    # Defines a method to access class instance.
    #
    # @example Create a namespace for products
    #   add_recommendable :products #=> SolidusRecommendations::Client::Products.new
    #
    def self.add_recommendable(name)
      converted = name.to_s.split('_').map(&:capitalize).join
      klass = SolidusRecommendations::Recommendable.const_get(converted)
      create_instance(klass)
    end

    ##
    # Dynamically creates an attr_reader for each client space
    # and sets it to the initalized values
    #
    def self.create_instance(klass)
      reader = klass.to_s.split('::').last.downcase
      define_method(reader.to_sym) { klass.new }
    end

    ##
    # Methods for product recommendations.
    #
    # @return [SolidusRecommendations::Recommendable::Products]
    #
    add_recommendable :products
  end
end
