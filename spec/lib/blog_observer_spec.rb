require 'spec_helper'
require './lib/blog_observer.rb'

describe BlogObserver do
  let(:blog_observer) { BlogObserver.new(params) }

  describe '#observe' do
    subject { blog_observer.observe }

    context 'and an UpdateAnalyzer' do
      let(:update_analyzer) { double('UpdateAnalyzer').as_null_object }
      let(:params) { { update_analyzer: update_analyzer } }

      context 'and an EmailSender' do
        let(:email_sender) { double('EmailSender').as_null_object }
        before(:each) { params[:email_sender] = email_sender  }

        it 'gets updates from the UpdateAnalyzer' do
          expect(update_analyzer).to receive(:updates)
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
