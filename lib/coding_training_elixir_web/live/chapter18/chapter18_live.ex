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
        %{"temperature" => temperature, "origin" => origin, "target" => target} = params,
        socket
      ) do
    case validate_integer(temperature) do
      {:ok, temperature} ->
        target_label = Map.get(@reverse_options, target)

        result =
          convert_temperature_unit(temperature, origin, target)
          |> generate_result_message(target_label)

        {:noreply, update_socket(socket, result, [], params)}

      {:error, message} ->
        {:noreply, update_socket(socket, "", [temperature: {message, []}], params)}
    end
  end

  def update_socket(
        socket,
        result,
        errors,
        %{"temperature" => _, "origin" => origin, "target" => target} = params
      ) do
    origin_label = Map.get(@reverse_options, origin)

    filtered_origin =
      Map.delete(@reverse_options, target) |> Map.new(fn {k, v} -> {v, k} end)

    filtered_target =
      Map.delete(@reverse_options, origin) |> Map.new(fn {k, v} -> {v, k} end)

    assign(socket,
      result: result,
      origin_label: origin_label,
      origin_options: filtered_origin,
      target_options: filtered_target,
      form: to_form(params, errors: errors)
    )
  end

  defp generate_result_message("", _), do: ""

  defp generate_result_message(result, target_label) do
    "변환된 #{target_label} 온도는 #{result} 입니다."
  end

  def convert_temperature_unit(temperature, origin, target) do
    case {origin, target} do
      {"F", "C"} -> fahrenheit_to_celsius(temperature)
      {"F", "K"} -> fahrenheit_to_kelvin(temperature)
      {"C", "F"} -> celsius_to_fahrenheit(temperature)
      {"C", "K"} -> celsius_to_kelvin(temperature)
      {"K", "F"} -> kelvin_to_fahrenheit(temperature)
      {"K", "C"} -> kelvin_to_celsius(temperature)
      _ -> ""
    end
  end

  def validate_integer(string) do
    case Integer.parse(string) do
      {int, ""} -> {:ok, int}
      _ -> {:error, "숫자가 아닌 값이 입력되었습니다."}
    end
  end

  def fahrenheit_to_kelvin(f) do
    fahrenheit_to_celsius(f) |> celsius_to_kelvin()
  end

  def kelvin_to_fahrenheit(k) do
    kelvin_to_celsius(k) |> celsius_to_fahrenheit()
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
