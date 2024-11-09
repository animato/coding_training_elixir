defmodule CodingTrainingElixirWeb.Chapter32Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", "ko")
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, locale)

    socket =
      assign(socket,
        form: to_form(%{}, errors: []),
        result: nil
      )

    {:ok, socket}
  end

  def handle_event("submit", %{} = params, socket) do
    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: nil
     )}
  end
end
