require 'yaml'
module Myroku

class Config

  def initialize(config_dir = nil)
    config_dir ||= File.expand_path("../../../config", __FILE__)
    @config_dir = config_dir
  end

  def method_missing(key)
    config[key.to_s]
  end

  private

  def config
    if @config.nil?
      @config = {}
      Dir.glob("#{@config_dir}/*.yml").each do |conf_file|
        key = File::basename(conf_file, '.yml')
        setting = YAML.load_file(conf_file)
        @config[key] = setting
      end
    end
    @config
  end

end

end
