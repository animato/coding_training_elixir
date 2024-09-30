defmodule CodingTrainingElixirWeb.Chapter16Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: to_form(%{"age" => nil}, errors: [])
      )

    {:ok, socket}
  end

  def handle_event("validate", %{"age" => age}, socket) do
    {:noreply,
     assign(socket,
       form: to_form(%{"age" => age}, errors: [])
     )}
  end

  def handle_event("save", %{"age" => age}, socket) do
    {age, _} = Integer.parse(age)

    {result, message} =
      if age < 16 do
        {:error, "법적으로 운전할 수 있는 나이가 아닙니다."}
      else
        {:info, "법적으로 운전할 수 있는 나이 입니다."}
      end

    {:noreply,
     socket
     |> assign(form: to_form(%{"age" => nil}, errors: []))
     |> put_flash(result, message)}
  end
end
