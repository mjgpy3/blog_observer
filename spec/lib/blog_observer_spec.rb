require 'spec_helper'
require './lib/blog_observer.rb'

describe BlogObserver do
  let(:blog_observer) { BlogObserver.new(params) }

  describe '#observe' do
    subject { blog_observer.observe }

    context 'when provided a ConfigurationReader' do
      let(:blogs) { double('Configured Blogs') }
      let(:configuration_reader) { double('ConfigurationReader', blogs: blogs) }
      let(:params) { { config: configuration_reader } }

      context 'and an UpdateAnalyzer' do
        let(:update_analyzer) { double('UpdateAnalyzer').as_null_object }
        before(:each) { params[:update_analyzer] = update_analyzer }

        context 'and an EmailSender' do
          let(:email_sender) { double('EmailSender').as_null_object }
          before(:each) { params[:email_sender] = email_sender  }

          it 'gets the desired blogs from the ConfigurationReader' do
            expect(configuration_reader).to receive(:blogs)
            subject
          end

          it 'gets updates from the UpdateAnalyzer using the configured blogs' do
            expect(update_analyzer).to receive(:updates).with(blogs)
            subject
          end

          context 'when there are updates' do
            let(:updates) { double('Updates', :empty? => false) }
            before(:each) { allow(update_analyzer).to receive(:updates).and_return(updates) }

            it 'emails the updates' do
              expect(email_sender).to receive(:send_updates).with(updates)
              subject
            end
          end

          context 'when there are no updates' do
            let(:updates) { double('Updates', :empty? => true) }
            before(:each) { allow(update_analyzer).to receive(:updates).and_return(updates) }

            it 'does not email the updates' do
              expect(email_sender).to_not receive(:send_updates).with(updates)
              subject
            end
          end
        end
      end
    end
  end
end
