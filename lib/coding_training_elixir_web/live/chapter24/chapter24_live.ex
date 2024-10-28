defmodule CodingTrainingElixirWeb.Chapter24Live do
  use CodingTrainingElixirWeb, :live_view

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
    {:noreply, redirect(socket, to: ~p"/chapter24?locale=#{language}")}
  end

  def handle_event(
        "submit",
        %{"word1" => word1, "word2" => word2} = params,
        socket
      ) do
    result =
      if is_anagram(word1, word2) do
        "애너그램 입니다."
      else
        "애너그램이 아닙니다."
      end

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: result
     )}
  end

  def is_anagram(word1, word2) do
    if String.length(word1) == String.length(word2) do
      word1_list = String.to_charlist(word1) |> Enum.sort()
      word2_list = String.to_charlist(word2) |> Enum.sort()
      word1_list == word2_list
    else
      false
    end
  end
end
