defmodule CodingTrainingElixirWeb.Chapter9Live do
  use CodingTrainingElixirWeb, :live_view
  @paint 9
  @meter "meter"

  def mount(_params, _session, socket) do
    socket = assign(socket, result: "결과가 여기에 나타납니다", unit_options: [미터: @meter])
    {:ok, socket}
  end

  def handle_event(
        "input-change",
        %{"length" => length, "width" => width, "unit" => unit},
        socket
      ) do
    case valid(length, width) do
      {:ok, {l, w}} ->
        area = l * w
        liter = Float.ceil(area / @paint) |> trunc
        result = print(liter, area)
        socket = assign(socket, result: result)
        {:noreply, socket}

      {:error, msg} ->
        socket = assign(socket, result: msg)
        {:noreply, socket}
    end
  end

  def print(liter, area) do
    "당신은 #{area} 제곱미터의 방을 칠하기 위해 #{liter} 리터의 페인트가 필요합니다.<br/>"
  end

  def valid(length, width) do
    with {l, ""} <- Integer.parse(length),
         {w, ""} <- Integer.parse(width),
         true <- l > 0,
         true <- w > 0 do
      {:ok, {l, w}}
    else
      :error -> {:error, "숫자가 아닌 값이 입력되었습니다."}
      _ -> {:error, "0 또는 음수 값 입력되었습니다."}
    end
  end
end
