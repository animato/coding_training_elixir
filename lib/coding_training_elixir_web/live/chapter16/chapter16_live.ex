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
    errors =
      case validate_integer(age) do
        {:ok, _} -> []
        {:error, message} -> [age: {message, []}]
      end

    {:noreply,
     assign(socket,
       form: to_form(%{"age" => age}, errors: errors)
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

  def validate_integer(string) do
    case Integer.parse(string) do
      {int, ""} when int > 0 -> {:ok, int}
      {_, ""} -> {:error, "0 또는 음수 값이 입력되었습니다."}
      _ -> {:error, "숫자가 아닌 값이 입력되었습니다."}
    end
  end
end
