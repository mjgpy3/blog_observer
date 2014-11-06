require 'spec_helper'
require './lib/blog_retriever.rb'

describe BlogRetriever do
  let(:blog_retriever) { BlogRetriever.new }

  describe '#retrieve' do
    subject { blog_retriever.retrieve(blog_details) }

    context 'when provided blog details' do
      let(:blog_details) { { 'link' => 'foo.bar.foo', 'title_xpath' => 'some xpath' } }
      before(:each) { allow(Net::HTTP).to receive(:get).and_return(double.as_null_object) }
      before(:each) { allow(Nokogiri).to receive(:XML).and_return(double.as_null_object) }

      it "gets the blog's HTML by its link" do
        expect(Net::HTTP).to receive(:get).with(blog_details['link'])
        subject
      end

      context 'after the HTML has been retrieved' do
        let(:html) { double('HTML') }
        before(:each) { allow(Net::HTTP).to receive(:get).and_return(html) }

        it 'creates a Nokogiri::XML document from it' do
          expect(Nokogiri).to receive(:XML).with(html)
          subject
        end

        describe 'the Nokogiri::XML document' do
          let(:nokogiri_document) { double('Nokogiri::XML') }
          before(:each) { allow(Nokogiri).to receive(:XML).and_return(nokogiri_document) }

          it "gets the blog's xpath applied to it" do
            expect(nokogiri_document).to receive(:xpath).with(blog_details['title_xpath'])
            subject
          end
        end
      end
    end
  end
end
