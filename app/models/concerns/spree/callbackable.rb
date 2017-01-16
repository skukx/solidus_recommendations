module Spree
  module Callbackable
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model

      after_commit :index_document, on: :create
      after_commit :update_document, on: :update
      after_commit :delete_document, on: :destroy

      delegate :delete_document, to: :__elasticsearch__

      ##
      # Index document into elasticsearch
      #
      def index_document
        __elasticsearch__.index_document(version_options)
      end

      ##
      # Updates elasticsearch document from featured model
      #
      def update_document
        __elasticsearch__.update_document(version_options)
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
