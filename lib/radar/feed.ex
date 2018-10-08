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

    asks = Map.get(parsed_message, "a") |> List.flatten()
    bids = Map.get(parsed_message, "b") |> List.flatten()

    asks_list = Enum.take_every(asks, 2)
                |> Enum.map(&String.to_float/1)
    asks_length =  Kernel.length(asks_list)

    bids_list = Enum.take_every(bids, 2)
                |> Enum.map(&String.to_float/1)
    bids_length =  Kernel.length(bids_list)

    if asks_length > bids_length do
      IO.puts "BTC/USD #{asks_length} sell walls detected at #{asks_list |> Enum.join(", ")}"
    else
      if bids_length > asks_length do
        IO.puts "BTC/USD #{bids_length} buy walls detected at #{bids_list |> Enum.join(", ")}"
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
