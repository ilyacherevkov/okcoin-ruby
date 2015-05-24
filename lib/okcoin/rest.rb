class Okcoin
  class Rest
    BASE_URI = "https://www.okcoin.com/api"
    TIMEOUT = 0.5

    def initialize(api_key: nil, secret_key: nil)
      @api_key = api_key
      @secret_key = secret_key
    end

    public

      def orderbook(pair:, items_no: 50)
        query = { "ok" => 1, "symbol" => pair, "size" => items_no }
        get_request(url: "/depth.do", query: query)
      end

      def futures_userinfo
        post_data = initial_post_data
        post_request post_data: post_data, action: "/v1/future_userinfo.do"
      end

      def equity
        post_data = initial_post_data
        post_request(post_data: post_data, action: "/v1/future_userinfo.do")["info"]["btc"]["account_rights"]
      end

      def futures_orderbook(pair:, contract:, items_no: 50)
        query = { "symbol" => pair, "contractType" => contract, "size" => items_no }
        get_request(url: "/future_depth.do", query: query)
      end

      def trade_futures(pair:, amount:, type:, contract_type:, match_price:, price: nil, lever_rate: 10)
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

      def future_cancel(pair:, contract_type:, order_id:)
        post_data = initial_post_data

        post_data["symbol"] = pair
        post_data["contract_type"] = contract_type
        post_data["order_id"] = order_id

        post_request post_data: post_data, action: "/v1/future_cancel.do"
      end

      def futures_orders_info(order_id:, symbol:, contract_type:)
        post_data = initial_post_data
        post_data["symbol"] = symbol
        post_data["contract_type"] = contract_type
        post_data["order_id"] = order_id

        post_request post_data: post_data, action: "/v1/future_orders_info.do"
      end

      def futures_position(pair:, contract_type:)
        post_data = initial_post_data
        post_data["symbol"] = pair
        post_data["contract_type"] = contract_type
        post_request post_data: post_data, action: "/v1/future_position.do"
      end


      def userinfo
        post_data = initial_post_data
        post_request post_data: post_data, action: "/v1/userinfo.do"
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