defmodule CodingTrainingElixirWeb.Chapter11Live do
  use CodingTrainingElixirWeb, :live_view
  @rate_to 100

  def mount(_params, _session, socket) do
    socket = assign(socket, valid: false, result: %{amount_from: 0, rate_from: 0, amount_to: 0})

    {:ok, socket}
  end

  # def handle_event("validate", %{"item" => items}, socket) do
  #   socket = assign(socket, items: list, valid: valid)
  #   {:noreply, socket}
  # end

  def handle_event(
        "input-submit",
        %{"amount_from" => amount_from, "rate_from" => rate_from},
        socket
      ) do
    {a, "" } = Integer.parse(amount_from)
    {r, "" } = Float.parse(rate_from)
    amount_to = calculate(a, r) |> Float.ceil(2)

    socket = assign(socket, :result, %{amount_from: a, rate_from: r, amount_to: amount_to})

    {:noreply, socket}
  end

  def calculate(amount_from, rate_from) do
    amount_from * rate_from / @rate_to
  end

  def error_message(price) do
    case valid_integer(price) do
      {:error, msg} -> [msg]
      _ -> []
    end
  end

  def valid_integer(nil) do
    {:error, "값이 입력되지 않았습니다."}
  end

  def valid_integer(string) do
    case Integer.parse(string) do
      {number, ""} when number > 0 -> {:ok, number}
      {_, ""} -> {:error, "0 또는 음수 값이 입력되었습니다."}
      _ -> {:error, "숫자가 아닌 값이 입력되었습니다."}
    end
  end

end
