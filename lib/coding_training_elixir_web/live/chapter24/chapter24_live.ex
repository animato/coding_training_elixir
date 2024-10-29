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

  def handle_event("change_language", %{"language" => language}, socket) do
    {:noreply, redirect(socket, to: ~p"/chapter24?locale=#{language}")}
  end

  def handle_event("submit", %{"word1" => word1, "word2" => word2} = params, socket) do
    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: anagram?(word1, word2) |> get_result_message()
     )}
  end

  def anagram?(word1, word2) do
    if String.length(word1) == String.length(word2) do
      list1 = String.to_charlist(word1) |> Enum.sort()
      list2 = String.to_charlist(word2) |> Enum.sort()
      list1 == list2
    else
      false
    end
  end

  def get_result_message(true), do: "애너그램 입니다."
  def get_result_message(false), do: "애너그램이 아닙니다."
end
