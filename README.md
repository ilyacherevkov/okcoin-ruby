# Okcoin API Ruby Wrapper
Unofficial ruby library for Okcoin Bitcoin Exchange

If you feel it's helpful and would like to donate, send coins to

```
BTC 15y2a3FKLW89qoDniDMRwsdhrZeHJA1Det
```

## Installation

Add these gems into your Gemfile:

```ruby
gem 'okcoin-ruby', '~> 0.0.5'
gem 'celluloid-websocket-client',  :github => 'ilyacherevkov/celluloid-websocket-client'
```

And then execute:

    $ bundle install

## Usage

### 1. REST Example
Initialize client
```ruby
okcoin = Okcoin::Rest.new api_key: ENV['OKCOIN_APIKEY'], secret_key: ENV['OKCOIN_SECRET']
```

Make requests

Spot Price
```ruby
okcoin.spot_ticker(pair: "btc_usd")
okcoin.spot_orderbook(pair: "btc_usd", items_no: 50, merge: 0)
okcoin.spot_trades(pair: "btc_usd", since: nil)
okcoin.spot_kandlestick(pair: "btc_usd", type: "30min", size: 50, since: nil)
okcoin.spot_swaps_orderbook(pair: "btc_usd")
```

Spot Trade
```ruby
okcoin.spot_userinfo
okcoin.spot_trade(pair: "btc_usd", type: "buy", price:240, amount:1)
```

Futures Price
```ruby
okcoin.futures_orderbook(pair: "btc_usd", contract: "this_week", items_no: 50)
```

Futures Trade
```ruby
okcoin.futures_userinfo
okcoin.futures_trade(pair: "btc_usd", amount: 1, type: 1, contract_type: "this_week", match_price: 1, price: nil, lever_rate: 10)
okcoin.futures_cancel(pair: "btc_usd", contract_type: "this_week", order_id: 12345)
okcoin.futures_order_info(order_id: 12345, symbol: "btc_usd", contract_type: "this_week", status: nil, current_page: nil, page_length: nil)
okcoin.futures_position(pair: "btc_usd", contract_type: "this_week")
```

### 2. WebSocket Example

```ruby
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
