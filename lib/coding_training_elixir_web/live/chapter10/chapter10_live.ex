defmodule CodingTrainingElixirWeb.Chapter10Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, result: "")
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

    result =
      Enum.map(list, fn x -> String.to_integer(x["price"]) * String.to_integer(x["quantity"]) end)
      |> Enum.sum()

    socket = assign(socket, :result, result)

    {:noreply, socket}
  end
end
