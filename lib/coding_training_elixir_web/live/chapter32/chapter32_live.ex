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
    with {max_number, ""} <- Integer.parse(max),
         {:ok, _} =
           NumberGuessingGameAgent.start_game(socket.assigns.user_id, max_number),
         {:ok, timer_ref} = :timer.send_interval(1000, self(), :tick) do
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
       result: result_to_msg(result, attempts),
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

  defp result_to_msg(:correct, count) when count == 1, do: "당신은 독심술사군요!"
  defp result_to_msg(:correct, count) when count < 5, do: "정말 인상적이에요."
  defp result_to_msg(:correct, count) when count < 7, do: "좀 더 잘할 수 있을 거예요."
  defp result_to_msg(:correct, count) when count >= 7, do: "다음엔 더 잘할 수 있을 거예요."
  defp result_to_msg(:below, _), do: "추측한 숫자가 답보다 낮음"
  defp result_to_msg(:above, _), do: "추측한 숫자가 답보다 높음"

  defp cancel_timer(timer_ref) when timer_ref != nil, do: :timer.cancel(timer_ref)
  defp cancel_timer(nil), do: nil

  defp format_time(seconds) do
    minutes = div(seconds, 60)
    seconds = rem(seconds, 60)
    :io_lib.format("~2..0B:~2..0B", [minutes, seconds])
  end
end
