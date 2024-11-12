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
        previous_guesses: [],
        attempts: 0,
        timer: 0,
        timer_ref: nil
      )

    {:ok, socket}
  end

  def handle_event("start", %{"max" => max} = params, socket) do
    max_number = String.to_integer(max)
    secret_number = :rand.uniform(max_number)

    IO.inspect(max_number)
    IO.inspect(secret_number)

    {:ok, timer_ref} = :timer.send_interval(1000, self(), :tick)

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: nil,
       secret_number: secret_number,
       game_active: true,
       previous_guesses: [],
       attempts: 0,
       timer: 0,
       timer_ref: timer_ref
     )}
  end

  def handle_event("submit", %{"guess" => guess} = params, socket) do
    previous_guesses = [guess | socket.assigns.previous_guesses]

    {result, game_active} =
      if socket.assigns.secret_number == String.to_integer(guess) do
        :timer.cancel(socket.assigns.timer_ref)
        {"정답", false}
      else
        {"오답", true}
      end

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: result,
       game_active: game_active,
       previous_guesses: previous_guesses,
       attempts: socket.assigns.attempts + 1
     )}
  end

  def handle_info(:tick, socket) do
    {:noreply, update(socket, :timer, fn timer -> timer + 1 end)}
  end
end
