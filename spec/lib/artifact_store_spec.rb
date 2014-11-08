require 'spec_helper'
require './lib/artifact_store.rb'

shared_examples 'it saves the given titles' do
  specify do
    expect(database_client).
      to receive(:save_titles).
      with('blogname', titles)

    subject
  end
end

shared_examples 'it returns the provided titles' do
  it { is_expected.to eq(titles) }
end

describe ArtifactStore do
  let(:artifact_store) { ArtifactStore.new(params) }

  describe '#store_and_get_deltas' do
    subject { artifact_store.store_and_get_deltas(name_and_titles) }
    let(:name_and_titles) { double(name: 'blogname', titles: titles) }

    context 'when provided a database client' do
      let(:database_client) { double('DatabaseClient', save_titles: nil) }
      let(:params) { { db: database_client } }

      context 'and titles are passed' do
        let(:titles) { ['title1', 'title2'] }

        context 'and the database client has no titles for the given name' do
          before(:each) do
            allow(database_client).
              to receive(:find_titles).
              with('blogname').
              and_return([])
          end

          it_behaves_like 'it saves the given titles'
          it_behaves_like 'it returns the provided titles'
        end

        context 'and the database client has different titles for the given name' do
          before(:each) do
            allow(database_client).
              to receive(:find_titles).
              with('blogname').
              and_return(['titlea', 'titleb'])
          end

          it_behaves_like 'it saves the given titles'
          it_behaves_like 'it returns the provided titles'
        end

        context 'and the database client has one of the two provided titles' do
          before(:each) do
            allow(database_client).
              to receive(:find_titles).
              with('blogname').
              and_return(['title2', 'titleb'])
          end

          it_behaves_like 'it saves the given titles'

          it 'returns the title that was provided but not in the database' do
            expect(subject).to eq(['title1'])
          end
        end

        context 'and the database client has the same as the provided titles' do
          before(:each) do
            allow(database_client).
              to receive(:find_titles).
              with('blogname').
              and_return(['title2', 'title1'])
          end

          it 'does not save the titles' do
            expect(database_client).to_not receive(:save_titles)
            subject
          end

          it { is_expected.to be_empty }
        end
      end
    end
  end
end
