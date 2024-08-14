defmodule CodingTrainingElixirWeb.Chapter7Live do
  use CodingTrainingElixirWeb, :live_view
  @convert_value 0.09290304

  def mount(_params, _session, socket) do
    socket = assign(socket, result: "결과가 여기에 나타납니다")
    {:ok, socket}
  end

  def handle_event("input-change", %{"length" => length, "width" => width}, socket) do
    case valid(length, width) do
      {:ok, {l, w}} ->
        sqfeet = l * w
        sqmeter = sqfeet_to_sqmeter(sqfeet)
        result = print(l, w, sqfeet, sqmeter)
        socket = assign(socket, result: result)
        {:noreply, socket}

      {:error, msg} ->
        IO.inspect(msg)
        socket = assign(socket, result: msg)
        {:noreply, socket}
    end
  end

  def print(length, width, sqfeet, sqmeter) do
    "당신이 입력한 방의 길이는 #{length} 피트, #{width} 피트 입니다.<br/> 
    면적은 
    #{sqfeet} 제곱피트<br/>
    #{sqmeter} 제곱미터 입니다."
  end

  def sqfeet_to_sqmeter(sqfeet) do
    sqfeet * @convert_value
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
