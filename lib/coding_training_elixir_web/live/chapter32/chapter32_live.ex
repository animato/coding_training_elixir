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
         timer: 0,
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
    {result, previous_guesses, attempts} =
      NumberGuessingGameAgent.guess_number(socket.assigns.user_id, guess)

    if result == :correct do
      cancel_timer(socket.assigns.timer_ref)
      NumberGuessingGameAgent.reset(socket.assigns.user_id)
    end

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: result_to_msg(result),
       game_active: game_active?(result),
       previous_guesses: previous_guesses,
       attempts: attempts
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

  def terminate(_reason, socket) do
    # 사용자의 Agent를 종료
    NumberGuessingGameAgent.reset(socket.assigns.user_id)
    cancel_timer(socket.assigns.timer_ref)
    :ok
  end

  defp game_active?(:correct), do: false
  defp game_active?(_), do: true

  defp result_to_msg(:correct), do: "정답입니다."
  defp result_to_msg(:below), do: "추측한 숫자가 답보다 낮음"
  defp result_to_msg(:above), do: "추측한 숫자가 답보다 높음"

  defp cancel_timer(timer_ref) when timer_ref != nil, do: :timer.cancel(timer_ref)
  defp cancel_timer(nil), do: nil
end
