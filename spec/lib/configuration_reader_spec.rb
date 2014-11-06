require 'spec_helper'
require './lib/configuration_reader.rb'

describe ConfigurationReader do
  let(:configuration_reader) { ConfigurationReader.new(path) }

  describe '#blogs' do
    subject { configuration_reader.blogs }

    context 'when initialized with a path' do
      let(:path) { 'some/path/to/config.yml' }

      it 'loads the path as YAML' do
        expect(YAML).to receive(:load_file).with(path).and_return(double.as_null_object)
        subject
      end

      context 'when the read YAML has a blog section' do
        let(:blogs) { double('Blogs') }
        before(:each) { allow(YAML).to receive(:load_file).and_return(blogs: blogs) }

        it 'returns the blogs section of the YAML' do
          expect(subject).to eq(blogs)
        end
      end
    end
  end
end
