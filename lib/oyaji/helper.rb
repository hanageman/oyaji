module Oyaji
  module Helper

    TABLES = {
      usage:  {
        name: "appUsage",
        times: %w(Day Week Month All),
        dimensions: %w(app company appVersion country language region category),
        metrics: %w(sessions activeDevices newDevices timeSpent averageTimePerDevice averageTimePerSession medianTimePerSession)
      },
      event: {
        name: "appEvent",
        times: %w(Day Week Month All),
        dimensions: %w(app company appVersion country language region category event),
        metrics: %w(activeDevices newDevices timeSpent averageTimePerDevice averageTimePerSession occurrences medianTimePerSession eventDuration)
      },
      params: {
        name: "eventParams",
        times: %w(Day Week Month All),
        dimensions: %w(app company appVersion country language region category event paramName paramValue),
        metrics: %w( count ),
      },
      real: {
        name: "realtime",
        times: %w(Hour Day All),
        dimensions: %w(company app appVersion country),
        metrics: %w(sessions activeDevices)
      },
    }

    def default_date(time_name = "Day")
      case time_name.downcase
      when "week" then
        d = ((Date.today - 7)..Date.today).select(&:monday?).first
        d..(d + 7)
      when "month" then
        d = Date.new(Date.today.year, Date.today.month, 1)
        d..(d.next_month)
      else
        (Date.today - 1)..Date.today
      end
    end

    def self.included(client)
      TABLES.each do |table_short_name, attributes|
        attributes[:times].each do |time_name|
          define_method "#{table_short_name}_#{time_name.downcase}" do |args = {}|
            args[:dimensions] = attributes[:dimensions] if args[:dimensions].nil?
            args[:metrics] = attributes[:metrics] if args[:metrics].nil?
            args[:date_range] = default_date(time_name) if args[:date_range].nil?

            request(attributes[:name], time_name, args)
          end
        end
      end
    end
  end
end
