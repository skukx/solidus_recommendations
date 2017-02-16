# frozen_string_literal: true
require 'spec_helper'

describe SolidusRecommendations::Recommendable::Products do
  describe SolidusRecommendations::Recommendable::Products::ACCEPTED_INDICES do
    its(:size) { is_expected.to eql 2 }
    it { is_expected.to include :user }
    it { is_expected.to include :order }
  end

  it { is_expected.to be_kind_of SolidusRecommendations::Recommendable::Base }
  it { is_expected.to respond_to :get }
end
