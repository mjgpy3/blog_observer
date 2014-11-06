class BlogObserver
  def initialize(params)
    @config = params[:config]
    @analyzer = params[:update_analyzer]
    @emailer = params[:email_sender]
  end

  def observe
    @emailer.send_updates(@analyzer.updates(@config.blogs))
  end
end
