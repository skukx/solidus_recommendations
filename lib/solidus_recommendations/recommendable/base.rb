# frozen_string_literal: true
module SolidusRecommendations
  module Recommendable
    class Base
      protected

      ##
      # Converts an Array of models to an array of their ids.
      # If the array is already the ids then nothing happens.
      #
      # @param [Array<Object, Integer>] items The array to convert to integers reprsenting model ids.
      # @return [Array<Integer>] An array of model ids.
      #
      def convert_to_id(items)
        items.map { |item| item.respond_to?(:id) ? item.id : item }
      end

      ##
      # Converts significant_terms aggregation buckets to
      # their respective models.
      #
      # @param [Object] aggregation The response from elasticsearch search query.
      # @param [Array<Integer>] excluded_ids The ids to exclude from results.
      # @param [Object] klass The respective model class.
      #
      # @return [Array<klass>] An array of the respective models.
      #
      def from_significant_terms(aggregation, excluded_ids, klass)
        items = []
        aggregation.buckets.each do |bucket|
          next if excluded_ids.include?(bucket[:key])
          item = klass.find_by(id: bucket[:key])
          next if item.nil?

          items << item
        end

        items
      end
    end
  end
end
