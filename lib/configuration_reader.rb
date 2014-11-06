require 'yaml'

class ConfigurationReader

  def initialize(path)
    @path = path
  end

  def blogs
    YAML.load_file(@path)
  end

end
