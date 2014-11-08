require 'spec_helper'
require './lib/emailer.rb'

describe Emailer do
  let(:emailer) { Emailer.new(params) }

  describe '#send_updates' do
    subject { emailer.send_updates(updates) }

    context 'when a ConfigurationReader is provided' do
      let(:config) { double('ConfigurationReader') }
      let(:params) { { config: config } }

      context 'and a MailPresenter is provided' do
        let(:mail_presenter) { double('MailPresenter') }
        before(:each) { params[:presenter] = mail_presenter }

        xit { '...' }
      end
    end
  end
end
