# stack = Faraday::Builder.new do |builder|
#   builder.use Faraday::HttpCache, store: Rails.cache
#   builder.response :logger
#   builder.use Ohanakapa::Response::RaiseError
#   builder.adapter Faraday.default_adapter
# end

Ohanakapa.configure do |config|
  if Rails.env.test?
    config.api_token = 'Ohana-API-Admin-Test'
  else
    config.api_token = ENV['OHANA_API_TOKEN']
  end

  if Rails.env.test?
    config.api_endpoint = 'http://ohana-api-test.herokuapp.com/api'
  elsif ENV['OHANA_API_ENDPOINT'].blank?
    raise 'The OHANA_API_ENDPOINT environment variable is not set! ' \
      'To set it locally, add it to config/application.yml.'
  else
    config.api_endpoint = ENV['OHANA_API_ENDPOINT']
  end
end

