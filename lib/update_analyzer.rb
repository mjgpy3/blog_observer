class UpdateAnalyzer
  def initialize(params)
    @retriever = params[:retriever]
    @blogs = params[:config].blogs
  end

  def updates
    @blogs.each do |blog|
      @retriever.retrieve(blog)
    end
  end
end
