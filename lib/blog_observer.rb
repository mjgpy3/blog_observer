class BlogObserver
  def initialize(params)
    @config = params[:config]
    @analyzer = params[:update_analyzer]
    @emailer = params[:email_sender]
  end

  def observe
    ->(updates) {
      @emailer.send_updates(updates) unless updates.empty?
    }.(@analyzer.updates(@config.blogs))
  end
end
