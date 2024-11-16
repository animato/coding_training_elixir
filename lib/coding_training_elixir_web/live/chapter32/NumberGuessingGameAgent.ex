defmodule CodingTrainingElixirWeb.NumberGuessingGameAgent do
  @moduledoc """
  숫자 맞추기 게임 에이전트
  """

  @doc """
  숫자 맞추기 게임 시작
  """
  def start_game(user_id, max_number, tick_callback) do
    {:ok, timer_ref} = :timer.send_interval(1000, tick_callback, :tick)

    case Agent.start_link(
           fn ->
             %{
               max_number: max_number,
               secret_number: :rand.uniform(max_number),
               previous_guesses: [],
               attempts: 0,
               timer_ref: timer_ref
             }
           end,
           name: user_id
         ) do
      {:ok, _} ->
        {:ok, %{result: nil, game_active: true, previous_guesses: [], attempts: 0}}

      _ ->
        {:error, %{result: nil, game_active: false, previous_guesses: [], attempts: 0}}
    end
  end

  def guess_number(user_id, guess) do
    %{
      secret_number: secret_number,
      previous_guesses: previous_guesses,
      attempts: attempts,
      timer_ref: timer_ref
    } =
      Agent.get(user_id, & &1)

    new = [guess | previous_guesses]

    Agent.update(user_id, fn x ->
      %{x | previous_guesses: new, attempts: attempts + 1}
    end)

    {result, game_active} = check_guess(secret_number, String.to_integer(guess))

    if not game_active do
      :timer.cancel(timer_ref)
      Agent.stop(user_id, :normal)
    end

    %{result: result, game_active: game_active, previous_guesses: new, attempts: attempts + 1}
  end

  def reset(user_id) do
    %{
      timer_ref: timer_ref
    } =
      Agent.get(user_id, & &1)

    :timer.cancel(timer_ref)
    Agent.stop(user_id, :normal)
  end

  defp check_guess(answer, guess) when answer == guess do
    {"정답", false}
  end

  defp check_guess(answer, guess) when answer > guess do
    {"추측한 숫자가 답보다 낮음", true}
  end

  defp check_guess(answer, guess) when answer < guess do
    {"추측한 숫자가 답보다 높음", true}
  end
end
