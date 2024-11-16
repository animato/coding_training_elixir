defmodule CodingTrainingElixirWeb.Chapter32Live do
  use CodingTrainingElixirWeb, :live_view
  alias CodingTrainingElixirWeb.NumberGuessingGameAgent

  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", "ko")
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, locale)

    socket =
      assign(socket,
        form: to_form(%{}, errors: []),
        result: "게임을 시작하려면 난이도를 선택하세요.",
        max_number: nil,
        game_active: false,
        previous_guesses: [],
        timer: 0,
        user_id: String.to_atom(:crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower))
      )

    {:ok, socket}
  end

  def handle_event("start", %{"max" => max} = params, socket) do
    max_number = String.to_integer(max)

    {:ok, result_map} =
      NumberGuessingGameAgent.start_game(socket.assigns.user_id, max_number, self())

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       max_number: max,
       result: result_map.result,
       game_active: result_map.game_active,
       game_mode: "mode",
       previous_guesses: result_map.previous_guesses,
       attempts: result_map.attempts
     )}
  end

  def handle_event("submit", %{"guess" => guess} = params, socket) do
    result_map = NumberGuessingGameAgent.guess_number(socket.assigns.user_id, guess)

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: result_map.result,
       game_active: result_map.game_active,
       previous_guesses: result_map.previous_guesses,
       attempts: result_map.attempts
     )}
  end

  def handle_event("reset", params, socket) do
    NumberGuessingGameAgent.reset(socket.assigns.user_id)

    {:noreply,
     assign(socket,
       form: to_form(%{}, errors: []),
       result: "게임을 시작하려면 난이도를 선택하세요.",
       max_number: nil,
       game_active: false,
       previous_guesses: [],
       timer: 0
     )}
  end

  def handle_info(:tick, socket) do
    {:noreply, update(socket, :timer, fn timer -> timer + 1 end)}
  end
end
