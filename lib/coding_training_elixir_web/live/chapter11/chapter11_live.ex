defmodule CodingTrainingElixirWeb.Chapter11Live do
  use CodingTrainingElixirWeb, :live_view
  @rate_to 100

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        valid: false,
        amount_from_error: [],
        rate_from_error: [],
        result: %{amount_from: 0, rate_from: 0, amount_to: 0}
      )

    {:ok, socket}
  end

  def handle_event("validate", %{"amount_from" => amount_from, "rate_from" => rate_from}, socket) do
    amount_from_error =
      case Integer.parse(amount_from) do
        {number, ""} when number > 0 -> []
        {_, ""} -> ["0 또는 음수 값이 입력되었습니다."]
        _ -> ["숫자가 아닌 값이 입력되었습니다."]
      end

    rate_from_error =
      case Float.parse(rate_from) do
        {number, ""} when number > 0 -> []
        {_, ""} -> ["0 또는 음수 값이 입력되었습니다."]
        _ -> ["실수가 아닌 값이 입력되었습니다."]
      end

    socket =
      assign(socket,
        valid: rate_from_error == [] and rate_from_error == [],
        amount_from_error: amount_from_error,
        rate_from_error: rate_from_error
      )

    {:noreply, socket}
  end

  def handle_event(
        "input-submit",
        %{"amount_from" => amount_from, "rate_from" => rate_from},
        socket
      ) do
    {a, ""} = Integer.parse(amount_from)
    {r, ""} = Float.parse(rate_from)
    amount_to = calculate(a, r) |> Float.ceil(2)

    socket = assign(socket, :result, %{amount_from: a, rate_from: r, amount_to: amount_to})

    {:noreply, socket}
  end

  def calculate(amount_from, rate_from) do
    amount_from * rate_from / @rate_to
  end
end
