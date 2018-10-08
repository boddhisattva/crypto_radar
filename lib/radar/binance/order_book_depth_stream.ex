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

  @ask :a
  @bid :b
  @flattened_list_price_element_index 2

  def price_list(order_book, order_book_info_type) do
    case order_book_info_type do
      "asks" ->
         order_book_info(order_book, @ask)
      "bids" ->
         order_book_info(order_book, @bid)
      _ ->
        raise IncorrectOrderBookInfoType
    end
    |> extract_price
  end

  defp extract_price(order_book_info) do
    order_book_info
    |> Enum.take_every(@flattened_list_price_element_index)
    |> Enum.map(&String.to_float/1)
  end

  defp order_book_info(order_book, order_book_info_type) do
    order_book
    |> Map.get(order_book_info_type)
    |> List.flatten()
  end
end

defmodule IncorrectOrderBookInfoType do
  defexception message: "Incorrect order book info type specified"
end