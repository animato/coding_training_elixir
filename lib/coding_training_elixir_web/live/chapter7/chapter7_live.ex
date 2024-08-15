defmodule CodingTrainingElixirWeb.Chapter7Live do
  use CodingTrainingElixirWeb, :live_view
  @convert_value 0.09290304
  @feet "feet"
  @meter "meter"

  def mount(_params, _session, socket) do
    socket = assign(socket, result: "결과가 여기에 나타납니다", unit_options: [피트: @feet, 미터: @meter])
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
        {counter_unit, counter_area} = calculate_counter_area(unit, area)
        result = print(l, w, area, counter_area, unit, counter_unit)
        socket = assign(socket, result: result)
        {:noreply, socket}

      {:error, msg} ->
        socket = assign(socket, result: msg)
        {:noreply, socket}
    end
  end

  def calculate_counter_area(@feet, area) do
    {@meter, area * @convert_value}
  end

  def calculate_counter_area(@meter, area) do
    {@feet, area / @convert_value}
  end

  def print(length, width, area, counter_area, unit, counter_unit) do
    "당신이 입력한 방의 길이는 #{length} #{unit}, #{width} #{unit} 입니다.<br/> 
    면적은 #{area} 제곱#{unit}<br/>
    #{counter_area} 제곱#{counter_unit} 입니다."
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
