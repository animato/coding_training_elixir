defmodule CodingTrainingElixirWeb.Chapter10Live do
  use CodingTrainingElixirWeb, :live_view
  @tax_rate 5.5

  def mount(_params, _session, socket) do
    socket = assign(socket, result: %{subtotal: 0, tax: 0, total: 0})
    {:ok, socket}
  end

  def handle_event(
        "input-submit",
        %{
          "item1" => item1,
          "item2" => item2,
          "item3" => item3
        },
        socket
      ) do
    list = [item1, item2, item3]

    subtotal =
      Enum.map(list, fn x -> String.to_integer(x["price"]) * String.to_integer(x["quantity"]) end)
      |> Enum.sum()

    tax = subtotal * @tax_rate / 100

    total = subtotal + tax
    socket = assign(socket, :result, %{subtotal: subtotal, tax: tax, total: total})

    {:noreply, socket}
  end
end
