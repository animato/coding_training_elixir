defmodule CodingTrainingElixirWeb.Chapter12Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        valid: false,
        principal: %{value: nil, error: []},
        interest: %{value: nil, error: []},
        years: %{value: nil, error: []},
        result: []
      )

    {:ok, socket}
  end

  def handle_event(
        "validate",
        %{"interest" => interest, "principal" => principal, "years" => years},
        socket
      ) do
    principal =
      case Integer.parse(principal) do
        {int, ""} when int > 0 -> %{value: principal, error: []}
        {_, ""} -> %{value: principal, error: ["0 또는 음수 값이 입력되었습니다."]}
        _ -> %{value: principal, error: ["숫자가 아닌 값이 입력되었습니다."]}
      end

    interest =
      case Float.parse(interest) do
        {float, ""} when float > 0 -> %{value: interest, error: []}
        {_, ""} -> %{value: interest, error: ["0 또는 음수 값이 입력되었습니다."]}
        _ -> %{value: interest, error: ["숫자가 아닌 값이 입력되었습니다."]}
      end

    years =
      case Integer.parse(years) do
        {int, ""} when int > 0 -> %{value: years, error: []}
        {_, ""} -> %{value: years, error: ["0 또는 음수 값이 입력되었습니다."]}
        _ -> %{value: years, error: ["숫자가 아닌 값이 입력되었습니다."]}
      end

    socket =
      assign(socket,
        valid: principal.error == [] and interest.error == [] and years.error == [],
        principal: principal,
        interest: interest,
        years: years,
        result: []
      )

    {:noreply, socket}
  end

  def handle_event(
        "input-submit",
        %{"interest" => interest, "principal" => principal, "years" => years},
        socket
      ) do
    principal =
      case Integer.parse(principal) do
        {int, ""} when int > 0 -> %{value: int, error: []}
        {_, ""} -> %{value: principal, error: ["0 또는 음수 값이 입력되었습니다."]}
        _ -> %{value: principal, error: ["숫자가 아닌 값이 입력되었습니다."]}
      end

    interest =
      case Float.parse(interest) do
        {float, ""} when float > 0 -> %{value: float, error: []}
        {_, ""} -> %{value: interest, error: ["0 또는 음수 값이 입력되었습니다."]}
        _ -> %{value: interest, error: ["숫자가 아닌 값이 입력되었습니다."]}
      end

    years =
      case Integer.parse(years) do
        {int, ""} when int > 0 -> %{value: int, error: []}
        {_, ""} -> %{value: years, error: ["0 또는 음수 값이 입력되었습니다."]}
        _ -> %{value: years, error: ["숫자가 아닌 값이 입력되었습니다."]}
      end

    result =
      Enum.map(1..years.value, fn year ->
        calculate =
          calculateSimpleInterest(principal.value, interest.value, year) |> Float.ceil(2)

        "연 #{interest.value}%, #{year}년 후 #{calculate}를 얻게 됩니다."
      end)

    socket =
      assign(socket,
        valid: false,
        principal: principal,
        interest: interest,
        years: years,
        result: result
      )

    {:noreply, socket}
  end

  def calculateSimpleInterest(p, r, t) do
    p * (1 + r / 100 * t)
  end
end
