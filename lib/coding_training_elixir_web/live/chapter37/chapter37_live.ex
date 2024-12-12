defmodule CodingTrainingElixirWeb.Chapter37Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", "ko")
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, locale)

    socket =
      assign(socket,
        form: to_form(%{}, errors: []),
        list: [],
        password: nil
      )

    {:ok, socket}
  end

  def handle_event(
        "generate",
        %{"length" => length, "special_chars" => special_chars, "numbers" => numbers} = params,
        socket
      ) do
    {length, _} = Integer.parse(length)
    {special_chars, _} = Integer.parse(special_chars)
    {numbers, _} = Integer.parse(numbers)

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       password: generate_password(length, special_chars, numbers)
     )}
  end

  def handle_event("copy", params, socket) do
    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       password: "password"
     )}
  end

  def generate_password(length, special_chars, numbers) do
    n_char = for _ <- 1..numbers, into: "", do: <<Enum.random(?0..?9)>>
    s_char = for _ <- 1..special_chars, into: "", do: <<Enum.random(~c"%@!^&*")>>
    a_char = for _ <- 1..(length - numbers - special_chars), into: "", do: <<Enum.random(?a..?z)>>

    (n_char <> s_char <> a_char)
    |> to_charlist()
    |> Enum.shuffle()
    |> List.to_string()
  end
end
