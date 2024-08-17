defmodule CodingTrainingElixirWeb.Chapter8Live do
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
        %{"people" => people, "pizzas" => pizzas, "pieces" => pieces},
        socket
      ) do
    case valid(people, pizzas, pieces) do
      {:ok, {people, pizzas, pieces}} ->
        total = pizzas * pieces
        gets = div(total, people)
        leftover = rem(total, people)
        result = print(people, pizzas, gets, leftover)
        socket = assign(socket, result: result)
        {:noreply, socket}

      {:error, msg} ->
        socket = assign(socket, result: msg)
        {:noreply, socket}
    end
  end

  def print(people, pizzas, gets, leftover) do
    "#{people} people with #{pizzas} pizzas <br/>
     Each person gets #{gets} pieces of pizza. <br/>
     There are #{leftover} leftover pieces.
    "
  end

  def valid(people, pizzas, pieces) do
    with {n1, ""} <- Integer.parse(people),
         {n2, ""} <- Integer.parse(pizzas),
         {n3, ""} <- Integer.parse(pieces),
         true <- n1 > 0,
         true <- n2 > 0,
         true <- n3 > 0 do
      {:ok, {n1, n2, n3}}
    else
      :error -> {:error, "숫자가 아닌 값이 입력되었습니다."}
      _ -> {:error, "0 또는 음수 값 입력되었습니다."}
    end
  end
end
