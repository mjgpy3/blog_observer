require 'spec_helper'
require './lib/configuration_reader.rb'

describe ConfigurationReader do
  let(:configuration_reader) { ConfigurationReader.new(path) }

  describe '#blogs' do
    subject { configuration_reader.blogs }

    context 'when initialized with a path' do
      let(:path) { 'some/path/to/config.yml' }

      it 'loads the path as YAML' do
        expect(YAML).to receive(:load_file).with(path)
        subject
      end
    end
  end
end
