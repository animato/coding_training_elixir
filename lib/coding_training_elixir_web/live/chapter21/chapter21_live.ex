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

  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", "ko")
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, locale)

    socket =
      assign(socket,
        form: to_form(%{"monthNumber" => nil}, errors: []),
        locale: locale,
        result: nil
      )

    {:ok, socket}
  end

  def handle_event(
        "change_language",
        %{"language" => language},
        socket
      ) do
    {:noreply, redirect(socket, to: ~p"/chapter21?locale=#{language}")}
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
       result: Gettext.gettext(CodingTrainingElixirWeb.Gettext, month_text)
     )}
  end

  def get_month_text(month_number) do
    Map.get(@month_map, month_number)
  end
end
