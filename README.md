# Okcoin API Ruby Wrapper
Unofficial ruby library for Okcoin Bitcoin Exchange

If you feel it's helpful and would like to donate, send coins to

```
BTC 15y2a3FKLW89qoDniDMRwsdhrZeHJA1Det
```

## Installation

Add these gems into your Gemfile:

```ruby
gem 'okcoin-ruby', '~> 0.0.6'
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

[See OKCoin REST API reference](https://www.okcoin.com/about/rest_api.do)

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
# max 5 orders in spot_batch_trade per request
okcoin.batch_spot_trade(pair: "btc_usd", type: "buy", orders_data: [{price:3,amount:5,type:'sell'},{price:3,amount:3,type:'buy'},{price:3,amount:3}])
# max 3 order_ids in spot_cancel per request 
okcoin.spot_cancel(pair: "btc_usd", order_id: "1234, 2345, 3456")
# -1 returns all unfilled orders, otherwise return the order specified
okcoin.spot_order_info(pair: "btc_usd", order_id: -1)
# max 50 orders per request
spot_orders_info(pair: "btc_usd", type: 0, order_id: "12345, 2345, 3456")
```

Futures Price
```ruby
okcoin.futures_orderbook(pair: "btc_usd", contract_type: "this_week", items_no: 50, merge: 0)
okcoin.futures_trades(pair: "btc_usd", contract_type: "this_week")
okcoin.futures_index(pair: "btc_usd")
okcoin.exchange_rate
okcoin.futures_estimated_price(pair: "btc_usd")
okcoin.futures_trades_history(pair: "btc_usd", date: nil, since: nil)
okcoin.futures_kandlestick(pair: "btc_usd", type: "30min", contract_type: "this_week", size: 50, since: nil)
okcoin.futures_hold_amount(pair: "btc_usd", contract_type: "this_week")
```

Futures Trade
```ruby
okcoin.futures_userinfo
okcoin.futures_trade(pair: "btc_usd", amount: 1, type: 1, contract_type: "this_week", match_price: 1, price: nil, lever_rate: 10)
okcoin.futures_cancel(pair: "btc_usd", contract_type: "this_week", order_id: 12345)
okcoin.futures_order_info(order_id: 12345, symbol: "btc_usd", contract_type: "this_week", status: nil, current_page: nil, page_length: nil)
okcoin.futures_position(pair: "btc_usd", contract_type: "this_week")
okcoin.futures_explosive(pair: "btc_usd", contract_type: "this_week", status: 0, current_page: 1, page_length: 50)
# status - 0: open liquidation orders of last 7 days; 1: filled liquidation orders of last 7 days
```

### 2. WebSocket Example
[See OKCoin WebSocket API reference](https://www.okcoin.com/about/ws_api.do)
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
