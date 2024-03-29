require 'net/http'
require 'nokogiri'

class XPathRetriever
  def initialize(get = Net::HTTP.method(:get), to_xml = Nokogiri.method(:XML))
    @get, @to_xml = get, to_xml
  end

  def retrieve(details)
    @to_xml.
      (@get.(URI.parse(details.link))).
      xpath(details.xpath).
      map(&:to_s)
  end
end
