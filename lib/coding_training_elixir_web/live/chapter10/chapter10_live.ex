defmodule CodingTrainingElixirWeb.Chapter10Live do
  use CodingTrainingElixirWeb, :live_view
  @tax_rate 5.5
  @init_item_count 3

  def mount(_params, _session, socket) do
    items =
      Enum.map(1..@init_item_count, fn _ ->
        empty_item()
      end)

    socket = assign(socket, items: items, valid: false, result: %{subtotal: 0, tax: 0, total: 0})

    {:ok, socket}
  end

  def handle_event("add", _, socket) do
    items = socket.assigns.items ++ [empty_item()]
    socket = assign(socket, items: items)
    {:noreply, socket}
  end

  def handle_event("validate", %{"item" => items}, socket) do
    list =
      Enum.map(items, fn {_, value} ->
        %{"price" => price, "quantity" => quantity} = value

        price_error = error_message(price)
        quantity_error = error_message(quantity)

        %{
          price: price,
          quantity: quantity,
          price_errors: price_error,
          quantity_errors: quantity_error
        }
      end)

    valid =
      Enum.all?(list, fn item ->
        item.price_errors == [] and item.quantity_errors == []
      end)

    socket = assign(socket, items: list, valid: valid)
    {:noreply, socket}
  end

  def handle_event(
        "input-submit",
        %{"item" => items},
        socket
      ) do
    list = Enum.map(items, fn {_, value} -> value end)

    subtotal =
      Enum.map(list, fn x -> String.to_integer(x["price"]) * String.to_integer(x["quantity"]) end)
      |> Enum.sum()

    tax = subtotal * @tax_rate / 100

    total = subtotal + tax
    socket = assign(socket, :result, %{subtotal: subtotal, tax: tax, total: total})

    {:noreply, socket}
  end

  def error_message(price) do
    case valid_integer(price) do
      {:error, msg} -> [msg]
      _ -> []
    end
  end

  def valid_integer(nil) do
    {:error, "값이 입력되지 않았습니다."}
  end

  def valid_integer(string) do
    case Integer.parse(string) do
      {number, ""} when number > 0 -> {:ok, number}
      {_number, ""} -> {:error, "0 또는 음수 값이 입력되었습니다."}
      _ -> {:error, "숫자가 아닌 값이 입력되었습니다."}
    end
  end

  defp empty_item do
    %{price: nil, quantity: nil, price_errors: [], quantity_errors: []}
  end
end
