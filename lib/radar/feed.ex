defmodule Feed do
  use WebSockex
  require Logger

  def start_link(opts \\ []) do
    url = "wss://stream.binance.com:9443/ws/btcusdt@depth"
    WebSockex.start_link(url, __MODULE__, :fake_state, opts)
  end

  def handle_connect(_conn, state) do
    Logger.info("Connected!")
    {:ok, state}
  end

  def handle_frame({:text, msg}, :fake_state) do
    Logger.info("Recieved message: #{msg}")
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
