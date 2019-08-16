require 'alphapoint/version'
require 'faye/websocket'
require 'eventmachine'
require 'yaml'
require 'active_support/all'

require 'alphapoint/configuration'
require 'alphapoint/web_socket'
require 'alphapoint/get_quotes'

module Alphapoint

	module Call
		REQUEST = 0
		REPLY = 1
		SUBSCRIBE = 2
		EVENT = 3
		UNSUBSCRIBE = 4
		ERROR = 5
	end

	class AlphapointError < StandardError

		def initialize(msg="Alphapoint error and conection failed")
		    super
		end

	end

	def self.response_of(type)
		if type == REQUEST
			REPLY
		elsif type == SUBSCRIBE
			EVENT
		end
	end

	class << self
		attr_accessor :configuration
	end

	def self.configuration
		@configuration ||= Configuration.new
	end

	def self.reset
		@configuration = Configuration.new
	end

	def self.configure
		yield(configuration)
	end

	def self.configure_with(path_to_yaml_file)
	    configure do |configuration|
	    	begin
		    	config = YAML.load(IO.read(path_to_yaml_file))

			    configuration.address = config.address
				configuration.user = config.user
				configuration.password = config.password

		    rescue Errno::ENOENT
		    #  log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
		    rescue Psych::SyntaxError
		    #  log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
		    end
	    end
	end

end
