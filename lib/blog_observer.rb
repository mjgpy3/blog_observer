class BlogObserver
  def initialize(params)
    @analyzer, @emailer = params.values_at(:update_analyzer, :email_sender)
  end

  def observe
    @emailer.send_updates(updates) unless updates.empty?
  end

  private

  def updates
    @updates ||= @analyzer.updates
  end
end
