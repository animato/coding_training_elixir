defmodule CodingTrainingElixirWeb.Chapter25Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", "ko")
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, locale)

    socket =
      assign(socket,
        form: to_form(%{"password" => nil}, errors: []),
        locale: locale,
        result: nil
      )

    {:ok, socket}
  end

  def handle_event("change_language", %{"language" => language}, socket) do
    {:noreply, redirect(socket, to: ~p"/chapter25?locale=#{language}")}
  end

  def handle_event("submit", %{"password" => password} = params, socket) do
    IO.puts(password)

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: password_validator(password)
     )}
  end

  def password_validator(password) do
    cond do
      has_number?(password) and has_alphabet?(password) and
        has_special?(password) and String.length(password) >= 8 ->
        :very_strong

      has_number?(password) and has_alphabet?(password) and
          String.length(password) >= 8 ->
        :strong

      has_alphabet?(password) and String.length(password) < 8 ->
        :weak

      true ->
        :very_weak
    end
  end

  def has_number?(password) do
    String.graphemes(password)
    |> Enum.any?(fn x -> Regex.match?(~r/^[0-9]$/, x) end)
  end

  def has_alphabet?(password) do
    String.graphemes(password)
    |> Enum.any?(fn x -> Regex.match?(~r/^[a-zA-Z]$/, x) end)
  end

  def has_special?(password) do
    String.graphemes(password)
    |> Enum.any?(fn x -> Regex.match?(~r/^[\W_]$/, x) end)
  end
end
