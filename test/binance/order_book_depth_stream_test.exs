defmodule Binance.OrderBookDepthStreamTest do
  use ExUnit.Case

  describe "price_list" do
    test "It extracts a list of prices related to the bids order book info type" do
      order_book = order_book_depth_stream_info()
      order_book_info_type = "bids"

      assert Binance.OrderBookDepthStream.price_list(order_book, order_book_info_type) ==
               [6667.16, 6666.0]
    end

    test "It extracts a list of prices related to the asks order book info type" do
      order_book = order_book_depth_stream_info()
      order_book_info_type = "asks"

      assert Binance.OrderBookDepthStream.price_list(order_book, order_book_info_type) ==
               [6668.98, 6669.18, 6669.23, 6822.0]
    end

    test "It raises an error for an incorrectly specified order book info type" do
      order_book = order_book_depth_stream_info()
      order_book_info_type = "random order book info type"

      assert_raise IncorrectOrderBookInfoType, "Incorrect order book info type specified", fn ->
        Binance.OrderBookDepthStream.price_list(order_book, order_book_info_type)
      end
    end
  end

  def order_book_depth_stream_info do
    %Binance.OrderBookDepthStream{
      E: 1_539_017_941_520,
      U: 260_960_815,
      a: [
        ["6668.98000000", "0.05793100", []],
        ["6669.18000000", "0.00000000", []],
        ["6669.23000000", "0.00000000", []],
        ["6822.00000000", "1.74932700", []]
      ],
      b: [["6667.16000000", "4.78806400", []], ["6666.00000000", "0.13463200", []]],
      e: "depthUpdate",
      s: "BTCUSDT",
      u: 260_960_822
    }
  end
end
