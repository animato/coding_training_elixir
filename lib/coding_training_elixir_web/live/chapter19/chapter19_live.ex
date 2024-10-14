defmodule CodingTrainingElixirWeb.Chapter19Live do
  use CodingTrainingElixirWeb, :live_view

  @units ["cm/kg", "inch/pound"]
  @height_range {0, 250}
  @weight_range {0, 200}

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: to_form(%{"height" => 180, "weight" => 79}, errors: []),
        units: @units,
        result: "",
        unit: %{"height" => "cm", "weight" => "kg"},
        height_range: @height_range,
        weight_range: @weight_range
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
    unit =
      if params["unit"] == "cm/kg" do
        %{"height" => "cm", "weight" => "kg"}
      else
        %{"height" => "inch", "weight" => "pound"}
      end

    height_range =
      if params["unit"] == "cm/kg" do
        @height_range
      else
        {cm_to_inch(0), cm_to_inch(250)}
      end

    weight_range =
      if params["unit"] == "cm/kg" do
        @weight_range
      else
        {kg_to_pound(0), kg_to_pound(250)}
      end

    assign(socket,
      result: generate_result_message(result),
      form: to_form(params, errors: errors),
      unit: unit,
      height_range: height_range,
      weight_range: weight_range
    )
  end

  defp generate_result_message(""), do: ""

  defp generate_result_message(bmi) do
    "당신의 BMI는 #{bmi} 입니다."
  end

  def validate_float(string) do
    case Float.parse(string) do
      {float, ""} -> {:ok, float}
      _ -> {:error, "숫자가 아닌 값이 입력되었습니다."}
    end
  end

  def cm_to_inch(cm) do
    cm * 0.393701
  end

  def kg_to_pound(kg) do
    kg * 2.20462
  end

  def calculate_bmi("inch/pound", height, weight) do
    weight / :math.pow(height, 2) * 703
  end

  def calculate_bmi("cm/kg", height, weight) do
    weight / :math.pow(height / 100, 2)
  end
end
