defmodule CodingTrainingElixirWeb.Chapter18Live do
  use CodingTrainingElixirWeb, :live_view

  @options [
    "화씨(Fahrenheit)": "F",
    "섭씨(Celsius)": "C",
    "켈빈(Kelvin)": "K"
  ]

  @reverse_options Map.new(@options, fn {k, v} -> {v, k} end)

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: to_form(%{"temperature" => nil}, errors: []),
        origin_label: "화씨(Fahrenheit)",
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
    origin_label = Map.get(@reverse_options, origin)
    target_label = Map.get(@reverse_options, target)

    filtered_origin =
      Map.delete(@reverse_options, target) |> Map.new(fn {k, v} -> {v, k} end)

    filtered_target =
      Map.delete(@reverse_options, origin) |> Map.new(fn {k, v} -> {v, k} end)

    case validate_integer(temperature) do
      {:ok, temperature} ->
        result =
          case {origin, target} do
            {"F", "C"} -> fahrenheit_to_celsius(temperature)
            {"F", "K"} -> fahrenheit_to_celsius(temperature) |> celsius_to_kelvin()
            {"C", "F"} -> celsius_to_fahrenheit(temperature)
            {"C", "K"} -> celsius_to_kelvin(temperature)
            {"K", "F"} -> kelvin_to_celsius(temperature) |> celsius_to_fahrenheit()
            {"K", "C"} -> kelvin_to_celsius(temperature)
            _ -> ""
          end

        {:noreply,
         assign(socket,
           result: generate_result_message(result, target_label),
           origin_label: origin_label,
           origin_options: filtered_origin,
           target_options: filtered_target,
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
           origin_label: origin_label,
           origin_options: filtered_origin,
           target_options: filtered_target,
           form:
             to_form(%{"temperature" => temperature, "origin" => origin, "target" => target},
               errors: [temperature: {message, []}]
             )
         )}
    end
  end

  defp generate_result_message("", _), do: ""

  defp generate_result_message(result, target_label) do
    "변환된 #{target_label} 온도는 #{result} 입니다."
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

  def celsius_to_fahrenheit(c) do
    c * 9 / 5 + 32
  end

  def celsius_to_kelvin(c) do
    c + 273.15
  end

  def kelvin_to_celsius(k) do
    k - 273.15
  end
end
