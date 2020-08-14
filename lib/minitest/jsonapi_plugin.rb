require 'uri'
require 'net/http'
require 'net/https'

module Minitest
	module JsonApi
		class Reporter < Minitest::StatisticsReporter
			attr_accessor :all_results, :addr, :apikeyname, :apikeyvalue, :pretty

			def initialize(options = {})
				super
				self.all_results = []

				self.addr = options[:addr]
				self.apikeyname = options[:apikeyname]
				self.apikeyvalue = options[:apikeyvalue]
				self.pretty = options[:pretty] || false

			end

			def record(result)
				super
				all_results << result
			end

			def report
				super

				assertions = 0
				skips = 0
				errors = 0
				fails = 0
				passes = 0

				results = all_results.collect do |result|
					status = case result.failure
					when Skip
						skips += 1
						:skip
					when UnexpectedError
						errors += 1
						:error
					when Assertion
						fails += 1
						:fail
					else
						passes += 1
						:pass
					end

					assertions += result.assertions

					result_hash = {
						name: result.name,
						status: status,
						time: result.time,
						assertions: result.assertions,
						file: nil,
						line: nil
					}

					if result.failure
						result_hash.merge!({
							file: result.source_location[0],
							line: result.source_location[1]
						})
					end

					result_hash

				end

				summary = {
					tests: all_results.count,
					assertions: assertions,
					passes: passes,
					fails: fails,
					errors: errors,
					skips: skips
				}


				full_result = {
					summary: summary,
					results: results
				}

				if addr.to_s.empty?
					if self.pretty
						io[:io].write(JSON.pretty_generate(full_result))
					else
						io[:io].write(JSON.dump(full_result))
					end
                else
                    uri = URI.parse(self.addr)
					header = {'Content-Type': 'text/json'}

					if self.apikeyname and self.apikeyvalue
						header[self.apikeyname] = apikeyvalue
					end

                    http = Net::HTTP.new(uri.host, uri.port)
					request = Net::HTTP::Post.new(uri.request_uri, header)
					request.body = full_result.to_json

					http.use_ssl = true if uri.scheme == 'https'

					begin
						http.request request
					rescue Exception => e
						puts "ERROR - #{e.message}"
					end
                end

			end
		end

	end
end


module Minitest
	def self.plugin_jsonapi_init(options)
		if JsonApi.enabled?
			reporter.reporters << JsonApi::Reporter.new(options)
		end
	end

	def self.plugin_jsonapi_options(opts, options)
		description = "Generate JSON to send"
		opts.on "-J", "--json", description do
			JsonApi.enable!
		end

		opts.on "--pretty", 'pretty print (for terminal output)' do
			options[:pretty] = true
		end

		opts.on "--addr [OPTIONAL]", String, "Full URL to send JSON to (http/https) .e.g https://api.com/test/results" do |url|
			options[:addr] = url
		end
		opts.on "--keyname [OPTIONAL]", String, "API Key Name" do |apikeyname|
			options[:apikeyname] = apikeyname
		end
		opts.on "--keyvalue [OPTIONAL]", String, "API Key Value" do |apikeyvalue|
			options[:apikeyvalue] = apikeyvalue
		end
	end


	module JsonApi
		@@enabled = false

		def self.enabled?
			@@enabled
		end

		def self.enable!
			@@enabled = true
		end

	end

end
