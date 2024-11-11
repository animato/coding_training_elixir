defmodule CodingTrainingElixirWeb.Chapter32Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", "ko")
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, locale)

    socket =
      assign(socket,
        form: to_form(%{}, errors: []),
        result: nil,
        game_active: false,
        attempts: 0,
        timer: 0
      )

    {:ok, socket}
  end

  def handle_event("start", %{"max" => max} = params, socket) do
    max_number = String.to_integer(max)
    secret_number = :rand.uniform(max_number)

    IO.inspect(max_number)
    IO.inspect(secret_number)

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: nil,
       secret_number: secret_number,
       game_active: true,
       attempts: 0,
       timer: 0
     )}
  end

  def handle_event("submit", %{} = params, socket) do
    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: nil
     )}
  end
end
