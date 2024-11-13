defmodule CodingTrainingElixirWeb.Chapter32Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", "ko")
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, locale)

    socket =
      assign(socket,
        form: to_form(%{}, errors: []),
        result: nil,
        max: nil,
        game_active: false,
        previous_guesses: [],
        attempts: 0,
        timer: 0,
        timer_ref: nil,
        user_id: String.to_atom(:crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower))
      )

    {:ok, socket}
  end

  def handle_event("start", %{"max" => max} = params, socket) do
    max_number = String.to_integer(max)
    secret_number = :rand.uniform(max_number)

    {:ok, agent} =
      Agent.start_link(fn -> secret_number end, name: socket.assigns.user_id)

    if socket.assigns.timer_ref != nil do
      :timer.cancel(socket.assigns.timer_ref)
    end

    {:ok, timer_ref} = :timer.send_interval(1000, self(), :tick)

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: nil,
       max: max_number,
       game_active: true,
       previous_guesses: [],
       attempts: 0,
       timer: 0,
       timer_ref: timer_ref
     )}
  end

  def handle_event("submit", %{"guess" => guess} = params, socket) do
    previous_guesses = [guess | socket.assigns.previous_guesses]
    secret_number = Agent.get(socket.assigns.user_id, & &1)

    {result, game_active} = check_guess(secret_number, String.to_integer(guess))

    if not game_active do
      :timer.cancel(socket.assigns.timer_ref)
      Agent.stop(socket.assigns.user_id, :normal)
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

  # def start_game(max_number) do
  #   %{secret_number: :rand.uniform(max_number), attempts: 0, previous_guesses: []}
  # end

  def check_guess(answer, guess) when answer == guess do
    {"정답", false}
  end

  def check_guess(answer, guess) when answer > guess do
    {"추측한 숫자가 답보다 낮음", true}
  end

  def check_guess(answer, guess) when answer < guess do
    {"추측한 숫자가 답보다 높음", true}
  end

  def handle_info(:tick, socket) do
    {:noreply, update(socket, :timer, fn timer -> timer + 1 end)}
  end
end
