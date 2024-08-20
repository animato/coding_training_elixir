defmodule CodingTrainingElixirWeb.Chapter8Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        result: "결과가 여기에 나타납니다",
        result2: "결과가 여기에 나타납니다"
      )

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
        IO.inspect("??")
        socket = assign(socket, result: msg)
        {:noreply, socket}
    end
  end

  def handle_event(
        "input-change2",
        %{"people" => people, "wanted" => wanted, "pieces" => pieces},
        socket
      ) do
    case valid(people, wanted, pieces) do
      {:ok, {people, wanted, pieces}} ->
        count = calculate(people * wanted, pieces)
        result = print2(count)
        socket = assign(socket, result2: result)
        {:noreply, socket}

      {:error, msg} ->
        socket = assign(socket, result: msg)
        {:noreply, socket}
    end
  end

  def pluralize("person", 1), do: "1 person"
  def pluralize("person", count), do: "#{count} people"
  def pluralize(word, 1), do: "1 #{word}"
  def pluralize(word, count), do: "#{count} #{word}s"

  def print(people, pizzas, gets, leftover) do
    "#{pluralize("person", people)} with #{pluralize("pizza", pizzas)} <br/>
     Each person gets #{pluralize("piece", gets)} of pizza. <br/>
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

  def calculate(needed, pieces) do
    div = div(needed, pieces)
    rem = rem(needed, pieces)
    div + if rem > 0, do: 1, else: 0
  end

  def print2(count) do
    "구매해야 하는 피자 수 #{count}"
  end
end
