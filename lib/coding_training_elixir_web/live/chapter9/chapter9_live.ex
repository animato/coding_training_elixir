defmodule CodingTrainingElixirWeb.Chapter9Live do
  use CodingTrainingElixirWeb, :live_view
  @paint 9
  @rectangle "rectangle"
  @ellipse "ellipse"

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        result: "",
        area: 0,
        liter: 0,
        shape_options: [사각형: @rectangle, 타원: @ellipse]
      )

    {:ok, socket}
  end

  def handle_event(
        "input-change",
        %{"length" => length, "width" => width, "shape" => shape},
        socket
      ) do
    case valid(length, width) do
      {:ok, {length, width}} ->
        area = area(length, width, shape)
        liter = calc_paint(area)
        socket = assign(socket, %{area: area, liter: liter})
        {:noreply, socket}

      {:error, msg} ->
        socket = assign(socket, result: msg)
        {:noreply, socket}
    end
  end

  def calc_paint(area), do: Float.ceil(area / @paint) |> trunc

  def area(length, width, shape) when shape == @ellipse do
    length / 2 * (width / 2) * :math.pi()
  end

  def area(length, width, shape) when shape == @rectangle do
    length * width
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
