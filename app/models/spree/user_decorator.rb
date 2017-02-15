# frozen_string_literal: true
Spree.user_class.include Spree::Callbackable
Spree.user_class.include Spree::User::Indexable
