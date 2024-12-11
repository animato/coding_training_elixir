defmodule CodingTrainingElixirWeb.Chapter37Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", "ko")
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, locale)

    socket =
      assign(socket,
        form: to_form(%{}, errors: []),
        list: [],
        password: nil
      )

    {:ok, socket}
  end

  def handle_event(
        "generate",
        %{"length" => length, "special_chars" => special_chars, "numbers" => numbers} = params,
        socket
      ) do
    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       password: "password"
     )}
  end

  def handle_event("copy", params, socket) do
    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       password: "password"
     )}
  end
end
