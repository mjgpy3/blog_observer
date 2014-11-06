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
    blog = retrieve(details)
    deltas = @artifacts.deltas(blog)
    deltas.empty? ? {} : { blog.name => @artifacts.deltas(blog) }
  end

  def retrieve(details)
    @retriever.retrieve(details)
  end
end
