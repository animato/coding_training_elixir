defmodule CodingTrainingElixirWeb.Chapter31Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", "ko")
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, locale)

    socket =
      assign(socket,
        form: to_form(%{"resting-hr" => nil, "age" => nil}, errors: []),
        result: nil
      )

    {:ok, socket}
  end

  def handle_event("submit", %{"resting-hr" => rest, "age" => age} = params, socket) do
    {rest, ""} = Integer.parse(rest)
    {age, ""} = Integer.parse(age)
    result = for x <- 55..95, rem(x, 5) == 0, do: {x, karvonen_hr(x, rest, age) |> round()}

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       result: result
     )}
  end

  def karvonen_hr(intence, rest, age) do
    (220 - age - rest) * (intence / 100) + rest
  end
end
