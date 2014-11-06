require 'spec_helper'
require './lib/update_analyzer.rb'

describe UpdateAnalyzer do
  let(:update_analyzer) { UpdateAnalyzer.new(params) }

  describe '#updates' do
    subject { update_analyzer.updates }

    context 'when provided a ConfigurationReader' do
      let(:configuration_reader) { double('ConfigurationReader', blogs: [blog_details1, blog_details2]) }
      let(:params) { { config: configuration_reader } }

      context 'with blog details' do
        let(:blog_details1) { double('Blog1 Details') }
        let(:blog_details2) { double('Blog2 Details') }

        context 'and provided an ArtifactStore' do
          let(:artifact_store) { double('ArtifactStore').as_null_object }
          before(:each) { params[:artifacts] = artifact_store }

          context 'and provided a BlogRetriever' do
            let(:blog_retriever) { double('BlogRetriever') }
            before(:each) { params[:retriever] = blog_retriever }

            it 'retrieves each blog' do
              expect(blog_retriever).to receive(:retrieve).with(blog_details1).and_return(double.as_null_object)
              expect(blog_retriever).to receive(:retrieve).with(blog_details2).and_return(double.as_null_object)
              subject
            end

            context 'after the blogs have been retrieved' do
              let(:blog1) { double('Blog1', name: 'blog1 title') }
              let(:blog2) { double('Blog2', name: 'blog2 title') }
              before(:each) do
                allow(blog_retriever).to receive(:retrieve).with(blog_details1).and_return(blog1)
                allow(blog_retriever).to receive(:retrieve).with(blog_details2).and_return(blog2)
              end

              it 'calculates deltas between each blog and the ArtifactStore' do
                expect(artifact_store).to receive(:deltas).with(blog1)
                expect(artifact_store).to receive(:deltas).with(blog2)
                subject
              end

              context 'when there are not deltas' do
                before(:each) do
                  allow(artifact_store).to receive(:deltas).and_return([])
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
                  allow(artifact_store).to receive(:deltas).with(blog1).and_return([delta1, delta2])
                  allow(artifact_store).to receive(:deltas).with(blog2).and_return([delta3, delta4, delta5])
                end

                it 'returns a hash of the blogs titles mapped to their deltas' do
                  expect(subject).
                    to eq('blog1 title' => [delta1, delta2], 'blog2 title' => [delta3, delta4, delta5])
                end
              end
            end
          end
        end
      end
    end
  end
end
