defmodule CodingTrainingElixirWeb.Chapter35Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", "ko")
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, locale)

    socket =
      assign(socket,
        form: to_form(%{}, errors: []),
        list: [],
        select: nil
      )

    {:ok, socket}
  end

  def handle_event("submit", %{"name" => name} = params, socket) do
    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       list: [name | socket.assigns.list]
     )}
  end

  def handle_event("select", params, socket) do
    {select, list} = select_person(socket.assigns.list)

    {:noreply,
     assign(socket,
       form: to_form(params, errors: []),
       list: list,
       select: select
     )}
  end

  def select_person([]) do
    {nil, []}
  end

  def select_person(list) do
    length = length(list)
    List.pop_at(list, :rand.uniform(length) - 1)
  end
end
