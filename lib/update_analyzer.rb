RetrievalDetails = Struct.new(:link, :xpath)

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
    deltas.empty? ? {} : {
      details['name'] => {
        deltas: @artifacts.deltas(title_list),
      }
    }
  end

  def retrieve_title_list(details)
    @retriever.retrieve(
      RetrievalDetails.new(details.values_at('link', 'title_xpath'))
    )
  end
end
