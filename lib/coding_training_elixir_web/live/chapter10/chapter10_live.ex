defmodule CodingTrainingElixirWeb.Chapter10Live do
  use CodingTrainingElixirWeb, :live_view
  @tax_rate 5.5
  @init_item_count 3

  def mount(_params, _session, socket) do
    item_price = %{price_or_quantity: "price", value: nil, errors: []}
    item_quantity = %{price_or_quantity: "quantity", value: nil, errors: []}

    items =
      Enum.flat_map(1..@init_item_count, fn _ ->
        [
          Map.new(item_price),
          Map.new(item_quantity)
        ]
      end)

    socket = assign(socket, items: items, result: %{subtotal: 0, tax: 0, total: 0})

    {:ok, socket}
  end

  def handle_event("add", _, socket) do
    items = socket.assigns.items ++ [%{price_or_quantity: nil, value: nil, errors: []}]
    socket = assign(socket, items: items)
    {:noreply, socket}
  end

  def handle_event("validate", %{"item" => items}, socket) do
    list =
      Enum.map(items, fn {_, value} ->
        case value do
          %{"price" => v} ->
            validate_field("price", v)

          %{"quantity" => v} ->
            validate_field("quantity", v)
        end
      end)

    socket = assign(socket, items: list)
    {:noreply, socket}
  end

  defp validate_field(field_type, value) do
    case valid(value) do
      {:ok, _} ->
        %{price_or_quantity: field_type, value: value, errors: []}

      {:error, msg} ->
        %{price_or_quantity: field_type, value: value, errors: [msg]}
    end
  end

  def valid(string) when string != nil do
    with {number, ""} <- Integer.parse(string),
         true <- number > 0 do
      {:ok, number}
    else
      :error -> {:error, "숫자가 아닌 값이 입력되었습니다."}
      _ -> {:error, "0 또는 음수 값 입력되었습니다."}
    end
  end

  def valid(string) when string == nil do
    {:error, "값 입력 안됨"}
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
end
