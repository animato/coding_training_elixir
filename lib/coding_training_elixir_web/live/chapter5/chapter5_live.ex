defmodule CodingTrainingElixirWeb.Chapter5Live do
  use CodingTrainingElixirWeb, :live_view
  @init_message "결과가 여기에 나타납니다"

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        result: @init_message,
        values: %{"number1" => nil, "number2" => nil},
        errors: %{"number1" => [], "number2" => []}
      )

    {:ok, socket}
  end

  def handle_event("input-change", %{"number1" => number1, "number2" => number2} = params, socket) do
    {valid_result1, valid_result2} = {valid_integer(number1), valid_integer(number2)}

    errors = collect_error({valid_result1, valid_result2})
    values = calculate_value({valid_result1, valid_result2})

    socket = assign(socket, result: values, values: params, errors: errors)
    {:noreply, socket}
  end

  def calculate_value({{:ok, n1}, {:ok, n2}}) do
    ["+", "-", "*", "/"]
    |> Enum.map(fn x -> calc(x, n1, n2) end)
    |> Enum.map(fn x -> print(x) end)
    |> Enum.join("<br/>")
  end

  def calculate_value({_, _}), do: @init_message

  def collect_error({{:ok, _}, {:ok, _}}), do: %{"number1" => [], "number2" => []}

  def collect_error({{:error, msg1}, {:error, msg2}}),
    do: %{"number1" => [msg1], "number2" => [msg2]}

  def collect_error({{:error, msg}, {_, _}}), do: %{"number1" => [msg], "number2" => []}
  def collect_error({{_, _}, {:error, msg}}), do: %{"number1" => [], "number2" => [msg]}

  def print({op, n1, n2, val}) do
    case op do
      "/" -> "#{n1} #{op} #{n2} = #{Float.to_string(val)}"
      _ -> "#{n1} #{op} #{n2} = #{Integer.to_string(val)}"
    end
  end

  def calc(op, n1, n2) do
    case op do
      "+" -> {op, n1, n2, n1 + n2}
      "-" -> {op, n1, n2, n1 - n2}
      "*" -> {op, n1, n2, n1 * n2}
      "/" -> {op, n1, n2, n1 / n2}
    end
  end

  def valid_integer("") do
    {:error, "값이 입력되지 않았습니다."}
  end

  def valid_integer(number) do
    with {int1, ""} <- Integer.parse(number),
         true <- int1 > 0 do
      {:ok, int1}
    else
      :error -> {:error, "정수가 아닌 값이 입력되었습니다."}
      _ -> {:error, "0 또는 음수가 입력되었습니다."}
    end
  end
end
