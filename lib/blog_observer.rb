class BlogObserver
  def initialize(params)
    @config, @analyzer, @emailer = params.values_at(:config, :update_analyzer, :email_sender)
  end

  def observe
    @emailer.send_updates(updates) unless updates.empty?
  end

  private

  def updates
    @updates ||= @analyzer.updates(@config.blogs)
  end
end
