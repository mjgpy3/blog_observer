require 'net/http'
require 'nokogiri'

class BlogRetriever
  def initialize(get = Net::HTTP.method(:get), to_xml = Nokogiri.method(:XML))
    @get = get
    @to_xml = to_xml
  end

  def retrieve(blog_details)
    xpath = blog_details['title_xpath']
    @to_xml.(@get.(blog_details['link'])).xpath(xpath)
  end
end
