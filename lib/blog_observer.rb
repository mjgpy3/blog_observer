class BlogObserver
  def initialize(params)
    @config = params[:config]
    @analyzer = params[:update_analyzer]
  end

  def observe
    @analyzer.updates(@config.blogs)
  end
end
