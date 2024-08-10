defmodule CodingTrainingElixirWeb.Chapter5Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, result: "결과가 여기에 나타납니다")
    {:ok, socket}
  end

  def handle_event("input-change", %{"number1" => number1, "number2" => number2}, socket) do
    case valid(number1, number2) do
      {:ok, {n1, n2}} ->
        plus = number1 <> " + " <> number2 <> " = " <> Integer.to_string(n1 + n2)
        minus = number1 <> " - " <> number2 <> " = " <> Integer.to_string(n1 - n2)
        multi = number1 <> " * " <> number2 <> " = " <> Integer.to_string(n1 * n2)
        divide = number1 <> " / " <> number2 <> " = " <> Float.to_string(n1 / n2)
        result = plus <> "<br/>" <> minus <> "<br/>" <> multi <> "<br/>" <> divide
        socket = assign(socket, result: result)
        {:noreply, socket}

      {:error, msg} ->
        socket = assign(socket, result: msg)
        {:noreply, socket}
    end
  end

  def valid(number1, number2) do
    with {int1, ""} <- Integer.parse(number1),
         {int2, ""} <- Integer.parse(number2),
         true <- int1 > 0,
         true <- int2 > 0 do
      {:ok, {int1, int2}}
    else
      :error -> {:error, "정수가 아닌 값이 입력되었습니다."}
      _ -> {:error, "0 또는 음수가 입력되었습니다."}
    end
  end
end
