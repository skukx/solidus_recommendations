# frozen_string_literal: true
module Spree
  module Indexable
    extend ActiveSupport::Concern

    included do
      ##
      # Override Index naming to add environment
      index_name index_name "#{name.gsub('::', '-').downcase}-#{Rails.env}"
    end
  end
end
