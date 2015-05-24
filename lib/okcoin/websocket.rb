module Okcoin
  class Websocket
    include Celluloid
    BASE_URI = 'wss://real.okcoin.com:10440/websocket/okcoinapi'

    def initialize(api_key: nil, secret_key: nil)
      @driver = Celluloid::WebSocket::Client.new(URL, Celluloid::Actor.current)
      @api_key = api_key
      @secret_key = secret_key
    end

    # When WebSocket is opened, register callbacks
    def on_open
     puts "Websocket connection to #{BASE_URI} established succesfully"
    end

    # When raw WebSocket message is received
    def on_message(msg)
      puts "Message received: #{msg}"
    end

    # When WebSocket is closed
    def on_close(code, reason)
      puts "WebSocket connection closed: #{code.inspect}, #{reason.inspect}"
      @driver.terminate
      terminate
    end

    # close WebSocket connection
    def close
      @driver.close
    end

    def pingpong
      every(5){ @driver.text "{'event':'ping'}" }
    end

    def userinfo
      post_data = initial_post_data
      emit(event: 'addChannel', channel: 'ok_spotusd_userinfo', post_data: post_data)
    end

    def futures_userinfo
      post_data = initial_post_data
      emit(event: 'addChannel', channel: 'ok_futureusd_userinfo', post_data: post_data)
    end

    def price_api(data)
      @driver.text data
    end

    private

      def initial_post_data
        post_data = {}
        post_data['api_key'] = @api_key
        post_data
      end

      def sign(post_data:)
        params_string = post_data.sort.collect{|k, v| "#{k}=#{v}"} * '&'
        hashed_string = params_string + "&secret_key=#{@secret_key}"
        signature = OpenSSL::Digest.new('md5', hashed_string).to_s.upcase
        post_data['sign'] = signature
        post_data = post_data.sort
        post_data.collect! { |item| "'#{item[0]}':'#{item[1]}'" }
        post_data = post_data.join(",")
      end

      def emit(event:, channel:, post_data: nil)
        post_data = sign(post_data: post_data)
        @driver.text  "{'event':'#{event}', 'channel':'#{channel}', 'parameters': {#{post_data}}}"
      end

  end
end