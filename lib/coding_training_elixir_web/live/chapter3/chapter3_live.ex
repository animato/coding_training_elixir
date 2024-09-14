defmodule CodingTrainingElixirWeb.Chapter3Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, result: "")
    {:ok, socket}
  end

  def handle_event("input-submit", %{"quote" => quote, "who" => who}, socket) do
    result = who <> " says, " <> "\"" <> quote <> "\""
    socket = assign(socket, result: result)
    {:noreply, socket}
  end
end
