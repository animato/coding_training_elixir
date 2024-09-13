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

  def handle_event("input-submit", %{"item" => items}, socket) do
    subtotal = calc_subtotal(items)
    tax = calc_tax(subtotal)
    total = subtotal + tax

    socket = assign(socket, :result, %{subtotal: subtotal, tax: tax, total: total})
    {:noreply, socket}
  end

  def calc_subtotal(items) do
    Enum.reduce(items, 0, fn {_, %{"price" => price, "quantity" => quantity}}, acc ->
      {p, _} = Integer.parse(price)
      {q, _} = Integer.parse(quantity)
      p * q + acc
    end)
  end
  
  def calc_tax(total) do
    total * @tax_rate / 100
  end

  def error_message(""), do: ["값이 입력되지 않았습니다."]
  def error_message(price) do
    case Integer.parse(price) do
      {number, ""} when number > 0 -> []
      {_, ""} -> ["0 또는 음수 값이 입력되었습니다."]
      _ -> ["숫자가 아닌 값이 입력되었습니다."]
    end
  end

  defp empty_item do
    %{price: nil, quantity: nil, price_errors: [], quantity_errors: []}
  end
end
