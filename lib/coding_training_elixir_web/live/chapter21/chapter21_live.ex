defmodule CodingTrainingElixirWeb.Chapter21Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: to_form(%{}, errors: [])
      )

    {:ok, socket}
  end

  def handle_event(
        "change",
        params,
        socket
      ) do
    {:noreply,
     assign(socket,
       form: to_form(params, errors: [])
     )}
  end
end
