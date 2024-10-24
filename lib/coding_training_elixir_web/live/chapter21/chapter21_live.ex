defmodule CodingTrainingElixirWeb.Chapter21Live do
  use CodingTrainingElixirWeb, :live_view

  @month_map %{
    "1" => "1월",
    "2" => "2월",
    "3" => "3월",
    "4" => "4월",
    "5" => "5월",
    "6" => "6월",
    "7" => "7월",
    "8" => "8월",
    "9" => "9월",
    "10" => "10월",
    "11" => "11월",
    "12" => "12월"
  }
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: to_form(%{"monthNumber" => nil}, errors: []),
        result: nil
      )

    # Gettext.put_locale(CodingTrainingElixirWeb.Gettext, "en")

    {:ok, socket}
  end

  def handle_event(
        "change",
        %{"monthNumber" => month_number, "language" => language} = params,
        socket
      ) do
    month_text = get_month_text(month_number)
    # gettext(month_text)
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, language)
    current_locale = Gettext.get_locale(CodingTrainingElixirWeb.Gettext)
    IO.puts("Current locale: #{current_locale}")

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: Gettext.gettext(CodingTrainingElixirWeb.Gettext, month_text)
     )}
  end

  def get_month_text(month_number) do
    Map.get(@month_map, month_number)
  end
end
