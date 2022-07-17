module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(env)
        env['simpler.route_params'] = {}

        method = env['REQUEST_METHOD'].downcase.to_sym
        request_path = env['PATH_INFO'].split('/').reject { |path| path.empty? }
        route_path = @path.split('/').reject { |path| path.empty? }

        if @method == method
          return false unless request_path.size == route_path.size

          compare = route_path.zip request_path

          compare.each do |pair|
            if pair[0].match?(/:(.*)/)
              puts pair[0].match(/:(.*)/)[1].to_sym
              env['simpler.route_params'][pair[0].match(/:(.*)/)[1].to_sym] = pair[1]
              puts env['simpler.route_params']
            else
              return false unless pair[0] == pair[1]
            end
          end
        end
      end

    end
  end
end
