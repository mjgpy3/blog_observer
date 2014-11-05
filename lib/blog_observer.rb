class BlogObserver
  def initialize(params)
    @config = params[:config]
  end

  def observe
    @config.blogs
  end
end
