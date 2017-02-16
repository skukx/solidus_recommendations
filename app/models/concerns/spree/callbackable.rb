# frozen_string_literal: true
module Spree
  module Callbackable
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model

      after_commit :index_document, on: :create
      after_commit :update_document, on: :update
      after_commit :delete_document, on: :destroy

      ##
      # Index document into elasticsearch
      #
      delegate :index_document, to: :__elasticsearch__

      ##
      # Updates elasticsearch document from featured model
      #
      def update_document
        __elasticsearch__.update_document
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        Rails.logger.warn "[#{self.class}] Document with id #{id} not found on elasticsearch cluster"
        __elasticsearch__.index_document
      end

      def delete_document
        __elasticsearch__.delete_document
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        Rails.logger.warn "[#{self.class}] Document with id #{id} not found on elasticsearch cluster"
      end

      private

      def version_options
        {
          version: (updated_at.to_f * 1000).to_i, # Include Milliseconds
          version_type: 'external'
        }
      end
    end
  end
end
