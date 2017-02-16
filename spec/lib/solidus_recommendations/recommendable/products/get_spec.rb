# frozen_string_literal: true
require 'spec_helper'

describe SolidusRecommendations::Recommendable::Products do
  describe '#get', elasticsearch: true do
    let(:product) { create(:product) }

    before do
      Spree.user_class.__elasticsearch__.create_index!
      Spree::Order.__elasticsearch__.create_index!
    end

    after do
      Spree.user_class.__elasticsearch__.client.indices.delete index: Spree.user_class.index_name
      Spree::Order.__elasticsearch__.client.indices.delete index: Spree::Order.index_name
    end

    context 'When product is nil' do
      let(:product) { nil }
      let(:invoked) { subject.get(product) }

      it 'should return an empty array' do
        expect(invoked).to be_kind_of Array
        expect(invoked).to be_empty
      end
    end

    context 'When product is an Object' do
      let(:product) { create(:product) }

      it "should use the object's id" do
        expect(subject).to receive(:user_index_significant_terms).with(product.id, anything).and_call_original
        subject.get(product)
      end
    end

    context 'When no options are passed' do
      it 'should default the index to :user' do
        expect(subject).to receive(:user_index_significant_terms).and_call_original
        subject.get(product)
      end

      it 'should default the size to 10' do
        expect(subject).to receive(:user_index_significant_terms).with(product.id, 10).and_call_original
        subject.get(product)
      end
    end

    context 'When an invalid index option is passed' do
      it 'should throw SolidusRecommendations::Errors::NonSupportedIndex' do
        expect { subject.get(product, index: :invalid) }.to raise_error SolidusRecommendations::Errors::NonSupportedIndex
      end
    end

    context 'When valid index option is passed' do
      context 'when index is :user' do
        it 'should query the user index' do
          expect(subject).to receive(:user_index_significant_terms).and_call_original
          subject.get(product, index: :user)
        end
      end

      context 'when index is :order' do
        it 'should query the order index' do
          expect(subject).to receive(:order_index_significant_terms).and_call_original
          subject.get(product, index: :order)
        end
      end
    end

    context 'When size is passed' do
      it 'should use the specified size' do
        expect(subject).to receive(:user_index_significant_terms).with(product.id, 15).and_call_original
        subject.get(product, size: 15)
      end
    end
  end
end
