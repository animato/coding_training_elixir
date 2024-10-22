defmodule CodingTrainingElixirWeb.Chapter21Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: to_form(%{}, errors: []),
        result: nil
      )

    {:ok, socket}
  end

  def handle_event(
        "change",
        %{"monthNumber" => month_number} = params,
        socket
      ) do
    month_text = get_month_text(month_number)

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: month_text
     )}
  end

  def get_month_text(month_number) do
    case month_number do
      "1" -> "1월"
      "2" -> "2월"
      "3" -> "3월"
      "4" -> "4월"
      "5" -> "5월"
      "6" -> "6월"
      "7" -> "7월"
      "8" -> "8월"
      "9" -> "9월"
      "10" -> "10월"
      "11" -> "11월"
      "12" -> "12월"
      _ -> nil
    end
  end
end
