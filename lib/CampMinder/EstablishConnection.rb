require "uri"
require "net/http"

class CampMinder::EstablishConnection
  include Virtus.model

  attribute :clientID, String
  attribute :personID, String
  attribute :token, String
  attribute :partnerClientID, String

  def initialize(data)
    @clientID = data.fetch("clientID")
    @personID = data.fetch("personID")
    @token = data.fetch("token")
    @partnerClientID = data.fetch("partnerClientID")
  end

  def payload
    to_xml(skip_instruct: true)
  end

  def signed_object
    signed_request_factory = CampMinder::SignedRequestFactory.new(CampMinder::SECRET_CODE)
    signed_request_factory.sign_payload(payload)
  end

  def connect
    uri = URI.parse(CampMinder::WEB_SERVICE_URL)
    http = nil

    if CampMinder::PROXY_URL.present?
      proxy_uri = URI.parse(CampMinder::PROXY_URL)
      http = Net::HTTP.new(uri.host, uri.port, proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
    else
      http = Net::HTTP.new(uri.host, uri.port)
    end

    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"fn" => "EstablishConnection", "businessPartnerID" => CampMinder::BUSINESS_PARTNER_ID, "signedObject" => signed_object})
    response = http.request(request)

    doc = Nokogiri.XML(response.body)
    success = doc.at_xpath("//status").content

    case success
    when "True"
      true
    when "False"
      @failure_details = doc.at_xpath("//details").content
      false
    end
  end

  def connection_failure_details
    @failure_details
  end

  def to_xml(options = {})
    require "builder"
    options[:indent] ||= 2
    builder = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    builder.instruct! unless options[:skip_instruct]
    builder.connectionRequest(version: "1") do |b|
      b.clientID @clientID
      b.personID @personID
      b.token @token
      b.partnerClientID @partnerClientID
    end
  end
end
