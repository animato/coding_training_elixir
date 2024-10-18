defmodule CodingTrainingElixirWeb.Chapter19Live do
  use CodingTrainingElixirWeb, :live_view

  @cm_to_inch_ratio 0.393701
  @kg_to_pound_ratio 2.20462

  @units ["metric", "imperial"]
  @unit_configs %{
    "metric" => %{
      "height_unit" => "cm",
      "weight_unit" => "kg",
      "height_min" => 100,
      "height_max" => 220,
      "weight_min" => 30,
      "weight_max" => 150
    },
    "imperial" => %{
      "height_unit" => "inch",
      "weight_unit" => "pound",
      "height_min" => ceil(100 * @cm_to_inch_ratio),
      "height_max" => ceil(220 * @cm_to_inch_ratio),
      "weight_min" => ceil(30 * @kg_to_pound_ratio),
      "weight_max" => ceil(150 * @kg_to_pound_ratio)
    }
  }

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: to_form(%{"height" => 180, "weight" => 70, "unit" => "metric"}, errors: []),
        units: @units,
        result: %{bmi: 0, width: "50%", color: "bg-blue-500", category: "저체중"},
        unit: Map.get(@unit_configs, "metric")
      )

    {:ok, socket}
  end

  def handle_event(
        "validate",
        %{"unit" => unit, "height" => height, "weight" => weight} = params,
        socket
      ) do
    bmi =
      with {height, _} <- Float.parse(height),
           {weight, _} <- Float.parse(weight) do
        calculate_bmi(unit, height, weight)
      else
        _ -> ""
      end

    {:noreply,
     assign(socket,
       result: result(bmi),
       form: to_form(params, errors: []),
       unit: Map.get(@unit_configs, params["unit"])
     )}
  end

  def result(bmi) do
    cond do
      bmi < 18.5 ->
        %{
          bmi: bmi,
          category: "저체중",
          width: "#{min(bmi / 40 * 100, 100)}%",
          color: "bg-blue-500"
        }

      bmi >= 18.5 and bmi < 23 ->
        %{
          bmi: bmi,
          category: "정상",
          width: "#{min(bmi / 40 * 100, 100)}%",
          color: "bg-green-500"
        }

      bmi >= 23 and bmi < 25 ->
        %{
          bmi: bmi,
          category: "과체중",
          width: "#{min(bmi / 40 * 100, 100)}%",
          color: "bg-yellow-500"
        }

      true ->
        %{
          bmi: bmi,
          category: "비만",
          width: "#{min(bmi / 40 * 100, 100)}%",
          color: "bg-red-500"
        }
    end
  end

  def validate_float(string) do
    case Float.parse(string) do
      {float, ""} -> {:ok, float}
      _ -> {:error, "숫자가 아닌 값이 입력되었습니다."}
    end
  end

  def calculate_bmi("imperial", height, weight) do
    weight / :math.pow(height, 2) * 703
  end

  def calculate_bmi("metric", height, weight) do
    weight / :math.pow(height / 100, 2)
  end
end
