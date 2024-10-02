defmodule CodingTrainingElixirWeb.Chapter18Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: to_form(%{"temperature" => nil}, errors: []),
        options: ["화씨(Fahrenheit) -> 섭씨(Celsius)": "C", "섭씨(Celsius) -> 화씨(Fahrenheit)": "F"],
        result: ""
      )

    {:ok, socket}
  end

  def handle_event("validate", %{"temperature" => temperature, "type" => type}, socket) do
    case validate_integer(temperature) do
      {:ok, temperature} ->
        result =
          case type do
            "C" -> fahrenheit_to_celsius(temperature)
            "F" -> celcius_to_fahrenheit(temperature)
          end

        {:noreply,
         assign(socket,
           result: "변환된 온도는 #{result} 입니다.",
           form: to_form(%{"temperature" => temperature, "type" => type}, errors: [])
         )}

      {:error, message} ->
        {:noreply,
         assign(socket,
           result: "",
           form:
             to_form(%{"temperature" => temperature, "type" => type},
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
