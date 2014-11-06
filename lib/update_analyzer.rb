require 'ostruct'

class UpdateAnalyzer
  def initialize(params)
    @retriever, @artifacts = params.values_at(:retriever, :artifacts)
    @blogs = params[:config].blogs
  end

  def updates
    @blogs.reduce({}) do |hsh, blog_details|
      hsh.merge(name_to_deltas(blog_details))
    end
  end

  private

  def name_to_deltas(details)
    title_list = retrieve_title_list(details)
    deltas = @artifacts.deltas(title_list)
    link = retrieve_link(details)
    deltas.empty? ? {} : {
      details['name'] => {
        deltas: @artifacts.deltas(title_list),
        link: link.first
      }
    }
  end

  def retrieve_link(details)
    @retriever.retrieve(
      OpenStruct.new(
        link: details['link'],
        xpath: details['link_xpath']
      )
    )
  end

  def retrieve_title_list(details)
    @retriever.retrieve(
      OpenStruct.new(
        link: details['link'],
        xpath: details['title_xpath']
      )
    )
  end
end
