defmodule Binance.OrderBookDepthStream do
  defstruct(
      e: "depthUpdate",
      E: 0,
      s: "",
      U: 0,
      u: 0,
      b: [],
      a: []
  )

  def asks_price_list(order_book) do
    order_book
    |> asks
    |> extract_price
  end

  def bids_price_list(order_book) do
    order_book
    |> bids
    |> extract_price
  end

  defp extract_price(order_info) do
    order_info
    |> Enum.take_every(2)
    |> Enum.map(&String.to_float/1)
  end

  defp asks(order_book) do
    Map.get(order_book, :a) |> List.flatten()
  end

  defp bids(order_book) do
    Map.get(order_book, :b) |> List.flatten()
  end
end