require 'alphapoint/version'
require 'faye/websocket'
require 'eventmachine'
require 'alphapoint/get_products'
require 'alphapoint/base'
require 'alphapoint/websocket'
require 'yaml'

module Alphapoint

	REQUEST = 0
	REPLY = 1
	SUBSCRIBE = 2
	EVENT = 3
	UNSUBSCRIBE = 4
	ERROR = 5

	def self.response_of(type)
		if type == REQUEST
			REPLY
		elsif type == SUBSCRIBE
			EVENT
		end
	end

	@config = {
		'address': '',
		'user': '',
		'password': ''
	}

	@valid_config_keys = @config.keys

	# Configure through hash
	def self.configure(opts = {})
		opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
	end

	def self.configure_with(path_to_yaml_file)
	    begin
	      config = YAML.load(IO.read(path_to_yaml_file))
	    rescue Errno::ENOENT
	      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
	    rescue Psych::SyntaxError
	      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
	    end

	    configure(config)
	end

	def self.config
    	@config
  	end

end


