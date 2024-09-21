defmodule CodingTrainingElixirWeb.Chapter13Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form1: %{
          principal: %{value: nil, error: []},
          interest: %{value: nil, error: []},
          years: %{value: nil, error: []},
          compound: %{value: nil, error: []},
          valid: false
        },
        result1: [],
        form2: %{
          total: %{value: nil, error: []},
          interest: %{value: nil, error: []},
          years: %{value: nil, error: []},
          compound: %{value: nil, error: []},
          valid: false
        },
        result2: []
      )

    {:ok, socket}
  end

  def handle_event("form1", params, socket) do
    fields = [
      principal: &validate_integer/1,
      interest: &validate_float/1,
      years: &validate_integer/1,
      compound: &validate_integer/1
    ]

    socket = update_values(socket, params, :form1, fields)

    case socket.assigns.form1.valid do
      true ->
        result =
          calculate_per_year(
            socket.assigns.form1.principal.value,
            socket.assigns.form1.interest.value,
            socket.assigns.form1.years.value,
            socket.assigns.form1.compound.value
          )

        {:noreply, assign(socket, result1: result)}

      false ->
        {:noreply, socket}
    end
  end

  def handle_event("form2", params, socket) do
    fields = [
      total: &validate_integer/1,
      interest: &validate_float/1,
      years: &validate_integer/1,
      compound: &validate_integer/1
    ]

    socket = update_values(socket, params, :form2, fields)

    case socket.assigns.form2.valid do
      true ->
        result =
          calculate_principal(
            socket.assigns.form2.total.value,
            socket.assigns.form2.interest.value,
            socket.assigns.form2.years.value,
            socket.assigns.form2.compound.value
          )

        {:noreply, assign(socket, result2: result)}

      false ->
        {:noreply, socket}
    end
  end

  defp update_values(socket, params, form_name, fields) do
    list = Enum.map(fields, fn {k, v} -> {k, v.(params[Atom.to_string(k)])} end)

    map = list |> Enum.into(%{})
    errors = list |> Enum.map(fn {_, v} -> v.error end) |> List.flatten()

    assign(socket, form_name, Map.put(map, :valid, errors == []))
  end

  def validate_integer(string) do
    case Integer.parse(string) do
      {int, ""} when int > 0 -> %{value: int, error: []}
      {_, ""} -> %{value: string, error: ["0 또는 음수 값이 입력되었습니다."]}
      _ -> %{value: string, error: ["숫자가 아닌 값이 입력되었습니다."]}
    end
  end

  def validate_float(string) do
    case Float.parse(string) do
      {float, ""} when float > 0 -> %{value: float, error: []}
      {_, ""} -> %{value: string, error: ["0 또는 음수 값이 입력되었습니다."]}
      _ -> %{value: string, error: ["숫자가 아닌 값이 입력되었습니다."]}
    end
  end

  def calculate_compound_interest(p, r, t, n) do
    p * :math.pow(1 + r / 100 / n, n * t)
  end

  def calculate_per_year(principal, interest, years, compound) do
    Enum.map(1..years, fn year ->
      calculate =
        calculate_compound_interest(principal, interest, year, compound) |> Float.ceil(2)

      "연 #{interest}%, #{year}년 후 #{calculate}를 얻게 됩니다."
    end)
  end

  def calculate_principal(a, r, t, n) do
    a / :math.pow(1 + r / 100 / n, n * t)
  end
end
