defmodule CodingTrainingElixirWeb.Chapter19Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: to_form(%{"height" => nil, "weight" => nil}, errors: []),
        result: ""
      )

    {:ok, socket}
  end

  def handle_event(
        "validate",
        %{"height" => height, "weight" => weight} = params,
        socket
      ) do
    with {height, _} <- Float.parse(height),
         {weight, _} <- Float.parse(weight) do
      bmi = calculate_bmi(height, weight)
      {:noreply, update_socket(socket, bmi, [], params)}
    else
      _ -> {:noreply, update_socket(socket, "", [], params)}
    end
  end

  def update_socket(
        socket,
        result,
        errors,
        %{"height" => height, "weight" => weight} = params
      ) do
    assign(socket,
      result: generate_result_message(result),
      form: to_form(params, errors: errors)
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

  def calculate_bmi(height, weight) do
    weight / :math.pow(height / 100, 2)
  end
end
