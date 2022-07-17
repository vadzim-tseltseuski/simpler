require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response
    attr_accessor :headers, :status

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers = @response.headers
      @route_params = {}
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      add_route_params
      send(action)
      set_default_headers
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      return @response['Content-Type'] = 'text/plain' if plain?

      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = plain? ? render_plain : render_view

      @response.write(body)
    end

    def params
      @request.params
    end

    def render_view
      View.new(@request.env).render(binding)
    end

    def render_plain
      "#{@request.env['simpler.template'][:plain]}\n"
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def status(status)
      @response.status = status
    end

    def plain?
      template = @request.env['simpler.template']
      template.is_a?(Hash) && template.key?(:plain)
    end

    def add_route_params
      @request.params.merge!(@request.env['simpler.route_params'])
      @request.env['simpler.params'] = @request.params
    end
  end
end
