class Okcoin
  class Rest
    BASE_URI = "https://www.okcoin.com/api"
    TIMEOUT = 0.5

    def initialize(api_key: nil, secret_key: nil)
      @api_key = api_key
      @secret_key = secret_key
    end

    public
      # Spot Price API
      def spot_ticker(pair: "btc_usd")
        query = { "symbol" => pair }
        get_request(url: "/v1/ticker.do", query: query)
      end

      def spot_orderbook(pair: "btc_usd", items_no: 50, merge: 0)
        query = { "symbol" => pair, "size" => items_no, "merge" => merge }
        get_request(url: "/v1/depth.do", query: query)
      end

      def spot_trades(pair: "btc_usd", since: nil)
        query = { "symbol" => pair, "since" => since }
        get_request(url: "/v1/trades.do", query: query)
      end

      def spot_kandlestick(pair: "btc_usd", type: "30min", size: 50, since: nil)
        query = { "symbol" => pair, "type" => type, "size" => size, "since" => since }
        get_request(url: "/v1/kline.do", query: query)
      end

      def spot_swaps_orderbook(pair: "btc_usd")
        query = { "symbol" => pair }
        get_request(url: "/v1/lend_depth.do", query: query)
      end

      # Spot Trading API

      def spot_userinfo
        post_data = initial_post_data
        post_request post_data: post_data, action: "/v1/userinfo.do"
      end

      def spot_trade(pair:, type:, price:, amount:)
        post_data = initial_post_data
        
        post_data["symbol"] = pair
        post_data["type"] = type
        post_data["amount"] = amount
        post_data["price"] = price

        post_request post_data: post_data, action: "/v1/trade.do"
      end

      # Futures Price API
      def futures_orderbook(pair:, contract:, items_no: 50)
        query = { "symbol" => pair, "contractType" => contract, "size" => items_no }
        get_request(url: "/future_depth.do", query: query)
      end

      # Futures Trading API
      def futures_userinfo
        post_data = initial_post_data
        post_request post_data: post_data, action: "/v1/future_userinfo.do"
      end

      def futures_trade(pair:, amount:, type:, contract_type:, match_price:, price: nil, lever_rate: 10)
        post_data = initial_post_data
        
        post_data["symbol"] = pair
        post_data["contract_type"] = contract_type
        post_data["amount"] = amount
        post_data["type"] = type
        post_data["match_price"] = match_price
        post_data["lever_rate"] = lever_rate

        post_data["price"] = price if price

        post_request post_data: post_data, action: "/v1/future_trade.do"
      end

      def futures_cancel(pair:, contract_type:, order_id:)
        post_data = initial_post_data

        post_data["symbol"] = pair
        post_data["contract_type"] = contract_type
        post_data["order_id"] = order_id

        post_request post_data: post_data, action: "/v1/future_cancel.do"
      end

      def futures_order_info(order_id:, symbol:, contract_type:, status: nil, current_page: nil, page_length: nil)
        post_data = initial_post_data
        post_data["symbol"] = symbol
        post_data["contract_type"] = contract_type
        post_data["order_id"] = order_id
        post_data["status"] = status
        post_data["current_page"] = current_page
        post_data["page_length"] = page_length

        post_request post_data: post_data, action: "/v1/future_order_info.do"
      end

      def futures_position(pair:, contract_type:)
        post_data = initial_post_data
        post_data["symbol"] = pair
        post_data["contract_type"] = contract_type
        post_request post_data: post_data, action: "/v1/future_position.do"
      end

    private 

      def handle_timeouts
        begin
          yield
        rescue => ex
          Rails.logger.info "Okcoin: An error of type #{ex.class} happened, message is #{ex.message}. Retrying..."
          sleep TIMEOUT
          retry
        end
      end

      def initial_post_data
        post_data = {}
        post_data["api_key"] = @api_key
        post_data
      end

      def post_request(post_data:, action:)
        params_string = post_data.sort.collect{|k, v| "#{k}=#{v}"} * '&'
        hashed_string = params_string + "&secret_key=#{@secret_key}"
        signature = OpenSSL::Digest.new("md5", hashed_string).to_s.upcase
        post_data["sign"] = signature

        payload = post_data.sort.collect{|k, v| "#{k}=#{v}"} * '&'
        
        handle_timeouts do
          request = Curl.post(BASE_URI + action, payload) do |request|
            request.headers['Content-type'] = 'application/x-www-form-urlencoded'
          end
          JSON.parse(request.body_str)
        end
      end

      def get_request(url:, query: nil)
        handle_timeouts do
          query ? JSON.parse(Curl.get(BASE_URI + url, query).body_str) : JSON.parse(Curl.get(BASE_URI + url).body_str)
        end
      end
  end
end