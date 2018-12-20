$LOAD_PATH << File.join(__dir__, 'lib')
require 'slack_proxy'

use Rack::CommonLogger
run
SlackProxy::SaleNotifier.new(ENV['SLACK_WEBHOOK_URL'], ENV['SLACK_USERNAME'])

