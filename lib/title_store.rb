require 'mongo'

class TitleStore
  def initialize
    @titles = Mongo::MongoClient.new['blog-observer']['titles']
  end

  def find_titles(blog_name)
    @titles.
      find(blog_name: blog_name)['titles'].
      to_a
  end

  def save_titles(blog_name, titles)
    @titles.update(
      { blog_name: blog_name },
      { blog_name: blog_name, titles: titles }
    )
  end
end
