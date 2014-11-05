require 'spec_helper'
require './lib/blog_observer.rb'

describe BlogObserver do
  let(:blog_observer) { BlogObserver.new(params) }

  describe '#observe' do
    subject { blog_observer.observe }

    context 'when provided a ConfigurationReader' do
      let(:configuration_reader) { double('ConfigurationReader') }
      let(:params) { { config: configuration_reader } }

      context 'and a FoundArtifactsStore' do
        let(:found_artifacts_store) { double('FoundArtifactsStore') }
        before(:each) { params[:artifacts] = found_artifacts_store  } 

        context 'and an EmailSender' do
          let(:email_sender) { double('EmailSender') }
          before(:each) { params[:email_sender] = email_sender  }

          it 'gets the desired blogs from the ConfigurationReader' do
            expect(configuration_reader).to receive(:blogs)
            subject
          end
        end
      end
    end
  end
end
