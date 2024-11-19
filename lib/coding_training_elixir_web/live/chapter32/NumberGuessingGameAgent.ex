defmodule CodingTrainingElixirWeb.NumberGuessingGameAgent do
  @moduledoc """
  숫자 맞추기 게임 에이전트
  """

  @doc """
  숫자 맞추기 게임 시작
  """
  def start_game(user_id, max_number) do
    Agent.start_link(
      fn -> initial_state(max_number) end,
      name: user_id
    )
  end

  defp initial_state(max_number) do
    %{
      max_number: max_number,
      secret_number: :rand.uniform(max_number),
      previous_guesses: [],
      attempts: 0
    }
  end

  def guess_number(user_id, guess) do
    %{
      secret_number: secret_number,
      previous_guesses: previous_guesses,
      attempts: attempts
    } =
      Agent.get(user_id, & &1)

    new = [guess | previous_guesses]

    Agent.update(user_id, fn x ->
      %{x | previous_guesses: new, attempts: attempts + 1}
    end)

    {result, game_active} = check_guess(secret_number, String.to_integer(guess))

    if not game_active do
      reset(user_id)
    end

    %{result: result, game_active: game_active, previous_guesses: new, attempts: attempts + 1}
  end

  def reset(user_id) do
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
