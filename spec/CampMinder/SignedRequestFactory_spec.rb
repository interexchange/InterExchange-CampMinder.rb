require 'spec_helper'

describe CampMinder::SignedRequestFactory do
  before do
    @signed_request_factory = CampMinder::SignedRequestFactory.new(CampMinder::SECRET_CODE)
  end

  describe '#initialize' do
    it 'initializes with secret attribute' do
      expect(@signed_request_factory).to be_an_instance_of CampMinder::SignedRequestFactory
      expect(@signed_request_factory.send(:secret_code)).to eq CampMinder::SECRET_CODE
    end

    it 'protects the secret_code' do
      expect do
        expect(@signed_request_factory.public_send(:secret_code)).to eq CampMinder::SECRET_CODE
      end.to raise_error NoMethodError
    end

    it 'initializes with secret attribute' do
      expect do
        CampMinder::SignedRequestFactory.new
      end.to raise_error ArgumentError
    end
  end

  describe '#is_valid_request?' do
    before do
      @payload = "Hello World"
      @encoded_payload = Base64.encode64(@payload)
    end

    it 'returns true if payload signed with SECRET_CODE' do
      @encoded_signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), CampMinder::SECRET_CODE, @encoded_payload)).strip()
      @signed_payload = "#{@encoded_signature}.#{@encoded_payload}"
      expect(@signed_request_factory.is_valid_request?(@signed_payload)).to eq true
    end

    it 'returns false if payload not signed with SECRET_CODE' do
      @encoded_signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), "lol", @encoded_payload)).strip()
      @signed_payload = "#{@encoded_signature}.#{@encoded_payload}"
      expect(@signed_request_factory.is_valid_request?(@signed_payload)).to eq false
    end
  end

  describe '#get_payload' do
    before do
      @payload = "Hello World"
      @encoded_payload = Base64.encode64(@payload)
      @encoded_signature = "ABC"
      @signed_payload = "#{@encoded_signature}.#{@encoded_payload}"
    end

    it 'decodes the last part of payload' do
      expect(@signed_request_factory.get_payload(@signed_payload)).to eq @payload
    end
  end
end
