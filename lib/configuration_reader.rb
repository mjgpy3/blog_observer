require 'yaml'

class ConfigurationReader

  def initialize(path)
    @path = path
  end

  def blogs
    config[:blogs]
  end

  private

  def config
    @config ||= YAML.load_file(@path)
  end

end
