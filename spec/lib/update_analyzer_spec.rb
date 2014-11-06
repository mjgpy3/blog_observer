require 'spec_helper'
require './lib/update_analyzer.rb'

describe UpdateAnalyzer do
  let(:update_analyzer) { UpdateAnalyzer.new(params) }

  describe '#updates' do
    subject { update_analyzer.updates }

    context 'when provided a ConfigurationReader' do
      let(:configuration_reader) { double('ConfigurationReader', blogs: blogs) }
      let(:params) { { config: configuration_reader } }

      context 'with 2 blogs' do
        let(:blogs) { [blog1, blog2] }
        let(:blog1) { double('Blog1') }
        let(:blog2) { double('Blog2') }

        context 'and provided an ArtifactStore' do
          let(:artifact_store) { double('ArtifactStore') }
          before(:each) { params[:artifacts] = artifact_store }

          context 'and provided a ArtifactRetriever' do
            let(:artifact_retriever) { double('ArtifactRetriever') }
            before(:each) { params[:retriever] = artifact_retriever }

            it 'retrieves each blog' do
              expect(artifact_retriever).to receive(:retrieve).with(blog1)
              expect(artifact_retriever).to receive(:retrieve).with(blog2)
              subject
            end
          end
        end
      end
    end
  end
end
