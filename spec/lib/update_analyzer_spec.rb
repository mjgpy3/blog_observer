require 'spec_helper'
require './lib/update_analyzer.rb'

shared_examples 'a databag where' do |method_to_expected_value|
  method_to_expected_value.each do |method, expected_value|
    describe "#{method}" do
      specify { expect(subject.send(method)).to eq(expected_value) }
    end
  end
end

describe 'RetrievalDetails.new("foo", "bar")' do
  subject { RetrievalDetails.new('foo', 'bar') }

  it_behaves_like 'a databag where', {
    'link' => 'foo',
    'xpath' => 'bar'
  }
end

describe 'BlogNameAndTitles.new("Some Blog", ["a", "b", "c"])' do
  subject { BlogNameAndTitles.new('Some Blog', ["a", "b", "c"]) }

  it_behaves_like 'a databag where', {
    'name' => 'Some Blog',
    'titles' => ["a", "b", "c"]
  }
end

describe UpdateAnalyzer do
  let(:update_analyzer) { UpdateAnalyzer.new(params) }

  describe '#updates' do
    subject { update_analyzer.updates }

    context 'when provided a ConfigurationReader' do
      let(:configuration_reader) { double('ConfigurationReader', blogs: [blog_details1, blog_details2]) }
      let(:params) { { config: configuration_reader } }

      context 'with blog details' do
        let(:blog_details1) { { 'link' => 'bee', 'title_xpath' => '/a/z/d', 'name' => 'blog1 name' } }
        let(:blog_details2) { { 'link' => 'cee', 'title_xpath' => '/e/f/', 'name' => 'blog2 name' } }

        context 'and provided an ArtifactStore' do
          let(:artifact_store) { double('ArtifactStore').as_null_object }
          before(:each) { params[:artifacts] = artifact_store }

          context 'and provided a BlogRetriever' do
            let(:xpath_retriever) { double('BlogRetriever') }
            before(:each) { params[:retriever] = xpath_retriever }

            it 'retrieves each blog' do
              expect(xpath_retriever).to receive(:retrieve).and_return(double.as_null_object).with(kind_of(RetrievalDetails)).twice
              subject
            end

            context 'after the blogs have been retrieved' do
              let(:blog1_titles) { double('Blog1 titles') }
              let(:blog2_titles) { double('Blog2 titles') }
              before(:each) do
                allow(xpath_retriever).to receive(:retrieve).and_return(blog1_titles, blog2_titles)
              end

              it 'calculates deltas between each blog and the ArtifactStore' do
                expect(artifact_store).to receive(:store_and_get_deltas).with(kind_of(BlogNameAndTitles)).twice
                subject
              end

              context 'when there are not deltas' do
                before(:each) do
                  allow(artifact_store).to receive(:store_and_get_deltas).and_return([])
                end

                it { is_expected.to eq({}) }
              end

              context 'and after the deltas have been calculated' do
                let(:delta1) { double('Delta1') }
                let(:delta2) { double('Delta2') }
                let(:delta3) { double('Delta3') }
                let(:delta4) { double('Delta4') }
                let(:delta5) { double('Delta5') }
                before(:each) do
                  allow(artifact_store).to receive(:store_and_get_deltas).and_return([delta1, delta2], [delta3, delta4, delta5])
                end

                it 'returns a hash of the blogs titles mapped to their deltas' do
                  expect(subject).
                    to eq('blog1 name' => { deltas: [delta1, delta2] }, 'blog2 name' => { deltas: [delta3, delta4, delta5] })
                end
              end
            end
          end
        end
      end
    end
  end
end
