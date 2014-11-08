require 'spec_helper'
require './lib/title_store.rb'

describe TitleStore do
  let(:title_store) { TitleStore.new }

  context 'when the client exists' do
    let(:client) { double }
    before(:each) do
      allow(Mongo::MongoClient).
        to receive(:new).
        and_return(client)
    end

    context 'and the blog-observer database exists' do
      let(:database) { double }
      before(:each) do
        allow(client).
          to receive(:[]).with('blog-observer').
          and_return(database)
      end

      context 'and the titles collection exists' do
        let(:titles) { { 'titles' => ['1', '2'] } }
        let(:collection) { double('TitlesCollection', find: [titles]) }
        before(:each) do
          allow(database).
            to receive(:[]).with('titles').
            and_return(collection)
        end

        context 'and a blog name is given' do
          let(:blog_name) { 'some blog' }

          describe '#save_titles' do
            subject { title_store.save_titles(blog_name, titles) }

            context 'and titles are given' do
              let(:titles) { double('titles') }

              it 'inserts the blogname and titles after deleting any matchers' do
                expect(collection).
                  to receive(:remove).
                  with(blog_name: blog_name).ordered

                expect(collection).
                  to receive(:insert).
                  with(blog_name: blog_name, titles: titles).ordered
                subject
              end
            end
          end

          describe '#find_titles' do
            subject { title_store.find_titles(blog_name) }

            it 'finds the titles, given the blog name' do
              expect(collection).
                to receive(:find).
                with(blog_name: 'some blog')
              subject
            end

            it 'equals the returned titles, converted to an array' do
              expect(subject).to eq(['1', '2'])
            end
          end
        end
      end
    end
  end
end
