require 'spec_helper'

describe SolidusRecommendations::Client do
  its(:class) { is_expected.to respond_to :add_recommendable }
  its(:class) { is_expected.to respond_to :create_instance }

  it { is_expected.to respond_to :products }
  its(:products) { is_expected.to be_instance_of SolidusRecommendations::Recommendable::Products }
end
