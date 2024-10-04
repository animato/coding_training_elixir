defmodule CodingTrainingElixirWeb.Chapter18Live do
  use CodingTrainingElixirWeb, :live_view

  @options [
    "화씨(Fahrenheit)": "F",
    "섭씨(Celsius)": "C"
  ]

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: to_form(%{"temperature" => nil}, errors: []),
        origin_options: @options,
        target_options: @options,
        result: ""
      )

    {:ok, socket}
  end

  def handle_event(
        "validate",
        %{"temperature" => temperature, "origin" => origin, "target" => target},
        socket
      ) do
    case validate_integer(temperature) do
      {:ok, temperature} ->
        result =
          case {origin, target} do
            {"F", "C"} -> fahrenheit_to_celsius(temperature)
            {"C", "F"} -> celcius_to_fahrenheit(temperature)
            _ -> temperature
          end

        type = Enum.find_value(@options, fn {k, v} -> if v == target, do: k end)

        {:noreply,
         assign(socket,
           result: "변환된 #{type} 온도는 #{result} 입니다.",
           form:
             to_form(%{"temperature" => temperature, "origin" => origin, "target" => target},
               errors: []
             )
         )}

      {:error, message} ->
        {:noreply,
         assign(socket,
           result: "",
           origin: origin,
           form:
             to_form(%{"temperature" => temperature, "origin" => origin, "target" => target},
               errors: [temperature: {message, []}]
             )
         )}
    end
  end

  def validate_integer(string) do
    case Integer.parse(string) do
      {int, ""} -> {:ok, int}
      _ -> {:error, "숫자가 아닌 값이 입력되었습니다."}
    end
  end

  def fahrenheit_to_celsius(f) do
    (f - 32) * 5 / 9
  end

  def celcius_to_fahrenheit(c) do
    c * 9 / 5 + 32
  end
end
