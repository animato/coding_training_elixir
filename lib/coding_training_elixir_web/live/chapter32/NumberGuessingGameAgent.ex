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
    Agent.get_and_update(user_id, fn state ->
      guess_result = check_guess(state.secret_number, String.to_integer(guess))
      new_previous_guesses = [guess | state.previous_guesses]
      new_attempts = state.attempts + 1

      {
        {guess_result, new_previous_guesses, new_attempts},
        %{state | previous_guesses: new_previous_guesses, attempts: new_attempts}
      }
    end)
  end

  def reset(user_id) do
    case Process.whereis(user_id) do
      nil -> false
      pid -> if Process.alive?(pid), do: Agent.stop(user_id, :normal)
    end
  end

  defp check_guess(answer, guess) when answer == guess, do: :correct
  defp check_guess(answer, guess) when answer > guess, do: :below
  defp check_guess(answer, guess) when answer < guess, do: :above
end
