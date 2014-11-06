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
        let(:blog_details1) { double('Blog1') }
        let(:blog_details2) { double('Blog2') }

        context 'and provided an ArtifactStore' do
          let(:artifact_store) { double('ArtifactStore') }
          before(:each) { params[:artifacts] = artifact_store }

          context 'and provided a BlogRetriever' do
            let(:blog_retriever) { double('BlogRetriever') }
            before(:each) { params[:retriever] = blog_retriever }

            it 'retrieves each blog' do
              expect(blog_retriever).to receive(:retrieve).with(blog_details1)
              expect(blog_retriever).to receive(:retrieve).with(blog_details2)
              subject
            end
          end
        end
      end
    end
  end
end
