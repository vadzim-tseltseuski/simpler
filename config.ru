require_relative 'lib/middleware/custom_logger'
require_relative 'config/environment'

use Middleware::CustomLogger, logdev: File.expand_path('log/app.log', __dir__)
run Simpler.application
