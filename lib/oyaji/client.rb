module Oyaji

  ENDPOINT_URL = "https://api-metrics.flurry.com/public/v1/data/"

  class Client

    include Oyaji::Helper

    attr_reader :api_key
    def initialize
      @api_key = ENV["FLURRY_API_KEY"]
    end

    def request(table, time, args = {})
      dimensions = args[:dimensions]
      metrics = args[:metrics]
      date_range = args[:date_range]

      url = build_url(table, time, dimensions, metrics, date_range)

      begin
        response = RestClient.get(url, headers)
      rescue => e
        response = JSON.parse(e.response)
        p response["description"] unless response.nil?
        p url
        raise e
      end

      Hashie::Mash.new(JSON.parse response)
    end

    def headers
      {
        Accept: "application/json",
        Authorization: "Bearer #{api_key}",
      }
    end

    def build_url(table, time, dimensions, metrics, date_range)

      dimensions = [dimensions] unless dimensions.is_a? Array
      metrics = [metrics] unless metrics.is_a? Array
      date_range = [date_range] unless date_range.is_a? Range

      dim_part = dimensions.join("/")
      metric_arg = "metrics=#{metrics.join(',')}"
      date_arg = "dateTime=#{date_range.first}/#{date_range.last}"

      "#{Oyaji::ENDPOINT_URL}#{table}/#{time}/#{dim_part}/?#{metric_arg}&#{date_arg}"
    end
  end
end
