require 'net/http'
require 'nokogiri'

#@doc = Nokogiri::XML(File.open("shows.xml"))
#@doc.xpath("//character")

class BlogRetriever
  def retrieve(blog_details)
    Nokogiri::XML(Net::HTTP.get(blog_details['link']))
  end
end
