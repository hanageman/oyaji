# Oyaji

Ruby wrapper for the [Flurry Analytics API](https://y.flurry.com/)

## Usage

```
# Initialization
client = Oyaji::Client.new

# Basic
client.request("appUsage", "Day", dimensions: :app, metrics: :activeDevices, date_range: Date.new(2017,1,1)..Date.new(2017,1,7))

=> #<Hashie::Mash rows=#<Hashie::Array [#<Hashie::Mash activeDevices...

# wrapper methods
usage_day, usage_week, usage_month, usage_all
event_day, event_week, event_month, event_all
real_hour, real_day, real_all

```

## ENV

```
FLURRY_API_KEY - Flurry Analytics API Key
```
