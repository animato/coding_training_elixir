defmodule CodingTrainingElixirWeb.Chapter11Live do
  use CodingTrainingElixirWeb, :live_view
  @rate_to 100
  @country ["미국": "USD", "대한민국": "KRW", "유럽연합": "EUR"]
  @rate_table %{"USD" => %{rate: 137.51, name: "dollars"}, "EUR" => %{rate: 100, name: "Euros"}, "KRW" => %{rate: 148_311, name: "원"}}


  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        valid: false,
        country: @country,
        amount_from_error: [],
        rate_from_error: [],
        result: %{amount_from: 0, rate_from: 0, amount_to: 0, name: ""}
      )

    {:ok, socket}
  end

  def handle_event("validate", %{"amount_from" => amount_from, "country" => country}, socket) do
    amount_from_error =
      case Integer.parse(amount_from) do
        {number, ""} when number > 0 -> []
        {_, ""} -> ["0 또는 음수 값이 입력되었습니다."]
        _ -> ["숫자가 아닌 값이 입력되었습니다."]
      end

    socket =
      assign(socket,
        valid: amount_from_error == [],
        amount_from_error: amount_from_error
      )

    {:noreply, socket}
  end

  def handle_event(
        "input-submit",
        %{"amount_from" => amount_from, "country" => country},
        socket
      ) do
    {a, ""} = Integer.parse(amount_from)

    rate_info = @rate_table[country]
    rate_from = rate_info.rate
    name = rate_info.name

    amount_to = calculate(a, rate_from) |> Float.ceil(2)

    socket =
      assign(socket, :result, %{amount_from: a, rate_from: rate_from, amount_to: amount_to, name: name})

    {:noreply, socket}
  end

  def calculate(amount_from, rate_from) do
    amount_from * rate_from / @rate_to
  end
end
