defmodule CodingTrainingElixirWeb.Chapter19Live do
  use CodingTrainingElixirWeb, :live_view

  @units ["cm/kg", "inch/pound"]
  @unit_configs %{
    "cm/kg" => %{
      "height_unit" => "cm",
      "weight_unit" => "kg",
      "height_min" => 0,
      "height_max" => 250,
      "weight_min" => 0,
      "weight_max" => 200
    },
    "inch/pound" => %{
      "height_unit" => "inch",
      "weight_unit" => "pound",
      "height_min" => 0,
      "height_max" => 100,
      "weight_min" => 0,
      "weight_max" => 440
    }
  }

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: to_form(%{"height" => nil, "weight" => nil}, errors: []),
        units: @units,
        result: "",
        position: position(0),
        unit: Map.get(@unit_configs, "cm/kg")
      )

    {:ok, socket}
  end

  def handle_event(
        "validate",
        %{"unit" => unit, "height" => height, "weight" => weight} = params,
        socket
      ) do
    with {height, _} <- Float.parse(height),
         {weight, _} <- Float.parse(weight) do
      bmi = calculate_bmi(unit, height, weight)
      {:noreply, update_socket(socket, bmi, [], params)}
    else
      _ -> {:noreply, update_socket(socket, "", [], params)}
    end
  end

  def update_socket(socket, result, errors, params) do
    assign(socket,
      result: result,
      position: position(result),
      form: to_form(params, errors: errors),
      unit: Map.get(@unit_configs, params["unit"])
    )
  end

  def position(bmi) do
    percentage =
      cond do
        bmi < 18.5 ->
          bmi / 18.5 * 25

        bmi >= 18.5 and bmi < 23 ->
          25 + (bmi - 18.5) / (23 - 18.5) * 25

        bmi >= 23 and bmi < 25 ->
          50 + (bmi - 23) / (25 - 23) * 25

        true ->
          75 + (bmi - 25) / (40 - 25) * 25
      end

    max(0, min(100, percentage))
  end

  def validate_float(string) do
    case Float.parse(string) do
      {float, ""} -> {:ok, float}
      _ -> {:error, "숫자가 아닌 값이 입력되었습니다."}
    end
  end

  def calculate_bmi("inch/pound", height, weight) do
    weight / :math.pow(height, 2) * 703
  end

  def calculate_bmi("cm/kg", height, weight) do
    weight / :math.pow(height / 100, 2)
  end
end
