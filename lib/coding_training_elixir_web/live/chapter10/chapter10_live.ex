defmodule CodingTrainingElixirWeb.Chapter10Live do
  use CodingTrainingElixirWeb, :live_view
  @tax_rate 5.5
  @init_item_count 3

  def mount(_params, _session, socket) do
    item = %{price: nil, quantity: nil}
    items = Enum.map(1..@init_item_count, fn _ -> Map.new(item) end)
    socket = assign(socket, items: items, result: %{subtotal: 0, tax: 0, total: 0})
    {:ok, socket}
  end

  def handle_event("add", _, socket) do
    items = socket.assigns.items ++ [%{price: nil, quantity: nil}]
    socket = assign(socket, items: items)
    {:noreply, socket}
  end

  def handle_event("validate", %{"item" => items}, socket) do
    list =
      Enum.map(items, fn {_, value} -> %{price: value["price"], quantity: value["quantity"]} end)

    socket = assign(socket, items: list)
    {:noreply, socket}
  end

  def handle_event(
        "input-submit",
        %{"item" => items},
        socket
      ) do
    # IO.inspect(items)

    list = Enum.map(items, fn {_, value} -> value end)

    # IO.inspect(list)

    subtotal =
      Enum.map(list, fn x -> String.to_integer(x["price"]) * String.to_integer(x["quantity"]) end)
      |> Enum.sum()

    tax = subtotal * @tax_rate / 100

    total = subtotal + tax
    socket = assign(socket, :result, %{subtotal: subtotal, tax: tax, total: total})

    {:noreply, socket}
  end
end
