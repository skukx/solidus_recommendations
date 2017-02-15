# frozen_string_literal: true
Spree::Order.include Spree::Callbackable
Spree::Order.include Spree::Order::Indexable
