defmodule CodingTrainingElixirWeb.Chapter2Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, session, socket) do
    socket = assign(socket, length: 0)
    {:ok, socket}
  end

  def handle_event("input-change", %{"input-text" => text}, socket) do
    socket = assign(socket, length: String.length(text))
    {:noreply, socket}
  end
end
