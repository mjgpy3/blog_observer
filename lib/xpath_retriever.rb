require 'net/http'
require 'nokogiri'

class XPathRetriever
  def initialize(get = Net::HTTP.method(:get), to_xml = Nokogiri.method(:XML))
    @get = get
    @to_xml = to_xml
  end

  def retrieve(details)
    @to_xml.(@get.(details.link)).xpath(details.xpath)
  end
end
