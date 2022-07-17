require 'logger'
require 'json'
module Middleware
  class CustomLogger

    def initialize(app, **options)
      FileUtils.touch "#{Simpler.root.join(options[:logdev])}"
      @logger = Logger.new(Simpler.root.join(options[:logdev] || STDOUT))
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)
      @logger.info(log_info(env, status, headers))
      [status, headers, response]
    end

    private

    def log_info(env, status, headers)
      template_path = " #{env['simpler.template_path']}" if env['simpler.template_path']

      {
        "Request" => "#{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}",
        "Handler" => "#{env['simpler.controller'].class}##{env['simpler.action']}",
        "Parameters" => env['simpler.params'],
        "Response" => "#{status} [#{headers['Content-Type']}]#{template_path}"
      }
    end
  end
end