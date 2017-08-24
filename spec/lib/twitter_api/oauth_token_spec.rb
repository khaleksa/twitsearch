require 'spec_helper'

describe TwitterApi::OauthToken do
  let(:key) { 'some_key' }
  let(:secret) { 'some_secret' }

  subject { described_class.new('/somepath/token', key, secret) }

  describe '#parsed_response' do
    let(:token) { 'app_oauth_token' }
    before do
      allow_any_instance_of(TwitterApi::OauthToken).to receive(:response).and_return({
                                                                                         'token_type' => 'bearer',
                                                                                         'access_token' => token
                                                                                     })
    end

    it 'should return oauth token value' do
      expect(subject.parsed_response).to eq(token)
    end
  end

  describe '#credentials' do
    let(:oauth_credentials) { Base64.strict_encode64("#{CGI.escape(key)}:#{CGI.escape(secret)}") }

    it 'should generate oauth credentials from key & secret' do
      expect(subject.credentials).to eq(oauth_credentials)
    end
  end

end
