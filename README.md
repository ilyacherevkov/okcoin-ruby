# Okcoin API Ruby Wrapper
Supports REST and Websocket protocols

## Installation

Add these gems into your Gemfile:

```ruby
gem 'okcoin-ruby'
gem 'celluloid-websocket-client',  :github => 'ilyacherevkov/celluloid-websocket-client'
```

And then execute:

    $ bundle install

## Usage

### 1. REST Example
```
okcoin = Okcoin::Rest.new api_key: ENV['OKCOIN_APIKEY'], secret_key: ENV['OKCOIN_SECRET']
puts okcoin.userinfo
puts okcoin.orderbook(pair: "btcusd", items_no: 50)
```

### 2. WebSocket Example

```
  okcoin = Okcoin::WS.new api_key: ENV['OKCOIN_APIKEY'], secret_key: ENV['OKCOIN_SECRET']
  okcoin.userinfo
  okcoin.pingpong
  okcoin.price_api("{'event':'addChannel','channel':'ok_btcusd_ticker'}")
  while true; sleep 1; end
  okcoin.close
``` 

## Contributing

1. Fork it ( https://github.com/[my-github-username]/okcoin-rest-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
