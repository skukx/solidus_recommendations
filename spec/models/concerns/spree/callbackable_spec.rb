require 'spec_helper'

describe Spree::Callbackable do
  let(:user) { create(:user) }
  subject { user }

  it { is_expected.to respond_to :index_document }
  it { is_expected.to respond_to :update_document }
  it { is_expected.to respond_to :delete_document }

  context 'when creating' do
    let(:user) { build(:user) }

    it 'should index the document' do
      expect(user.__elasticsearch__).to receive(:index_document).and_call_original
      user.save
    end
  end

  context 'when updating' do
    context 'when document is indexed' do
      it 'should update the document' do
        expect(user.__elasticsearch__).to receive(:update_document).and_call_original
        user.update(email: 'test@example.com')
      end
    end

    context 'when document is NOT indexed' do
      it 'is expected to index the document' do
        user.delete_document
        expect(user.__elasticsearch__).to receive(:index_document).and_call_original
        expect { user.update_document }.to_not raise_error Elasticsearch::Transport::Transport::Errors::NotFound
      end
    end
  end

  context 'when deleting' do
    context 'when document is indexed' do
      it 'should delete the document' do
        expect(user.__elasticsearch__).to receive(:delete_document).and_call_original
        user.delete_document
      end
    end

    context 'when document is NOT indexed' do
      it 'should NOT raise Elasticsearch::Transport::Transport::Errors::NotFound' do
        user.delete_document
        expect { user.delete_document }.to_not raise_error Elasticsearch::Transport::Transport::Errors::NotFound
      end
    end
  end
end
