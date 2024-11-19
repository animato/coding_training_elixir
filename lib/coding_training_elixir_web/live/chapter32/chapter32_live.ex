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
        timer_ref: nil,
        user_id: String.to_atom(:crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower))
      )

    {:ok, socket}
  end

  def handle_event("start", %{"max" => max} = params, socket) do
    max_number = String.to_integer(max)

    {start, _} =
      NumberGuessingGameAgent.start_game(socket.assigns.user_id, max_number)

    if start == :ok do
      {:ok, timer_ref} = :timer.send_interval(1000, self(), :tick)

      {:noreply,
       assign(socket,
         form: to_form(params, errors: []),
         max_number: max,
         result: nil,
         game_active: true,
         previous_guesses: [],
         attempts: 0,
         timer_ref: timer_ref
       )}
    else
      {:noreply,
       assign(socket,
         form: to_form(params, errors: [])
       )}
    end
  end

  def handle_event("submit", %{"guess" => guess} = params, socket) do
    result_map = NumberGuessingGameAgent.guess_number(socket.assigns.user_id, guess)

    if not result_map.game_active, do: cancel_timer(socket.assigns.timer_ref)

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: result_map.result,
       game_active: result_map.game_active,
       previous_guesses: result_map.previous_guesses,
       attempts: result_map.attempts
     )}
  end

  def handle_event("reset", _, socket) do
    NumberGuessingGameAgent.reset(socket.assigns.user_id)

    cancel_timer(socket.assigns.timer_ref)

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

  def terminate(reason, socket) do
    # 사용자의 Agent를 종료

    IO.inspect(reason)
    NumberGuessingGameAgent.reset(socket.assigns.user_id)
    cancel_timer(socket.assigns.timer_ref)
    :ok
  end

  defp cancel_timer(timer_ref) when timer_ref != nil, do: :timer.cancel(timer_ref)
  defp cancel_timer(nil), do: nil
end
