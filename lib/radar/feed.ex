defmodule Feed do
  use WebSockex
  require Logger

  def start_link(opts \\ []) do
    url = "wss://stream.binance.com:9443/ws/btcusdt@depth"
    WebSockex.start_link(url, __MODULE__, :fake_state, opts)
  end

  def handle_connect(_conn, state) do
    {:ok, state}
  end

  def handle_frame({:text, msg}, :fake_state) do
    parsed_message = Jason.decode!(msg)
    par_msg = for {key, val} <- parsed_message, into: %{}, do: {String.to_atom(key), val}
    order_book = struct(Binance.OrderBookDepthStream, par_msg)

    asks_price_list = Binance.OrderBookDepthStream.asks_price_list(order_book)
    asks_length =  Kernel.length(asks_price_list)
    bids_price_list = Binance.OrderBookDepthStream.bids_price_list(order_book)
    bids_length = Kernel.length(bids_price_list)

    if asks_length > bids_length do
      IO.puts "BTC/USD #{asks_length} sell walls detected at #{asks_price_list |> Enum.join(", ")}"
    else
      if bids_length > asks_length do
        IO.puts "BTC/USD #{bids_length} buy walls detected at #{bids_price_list |> Enum.join(", ")}"
      else
      end
    end

    {:ok, :fake_state}
  end

  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.info("Local close with reason: #{inspect reason}")
    {:ok, state}
  end

  def handle_disconnect(disconnect_map, state) do
    super(disconnect_map, state)
  end
end
