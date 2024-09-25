defmodule CodingTrainingElixirWeb.Chapter14Live do
  @wisconsin ["wisconsin", "wi"]
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form1: %{
          order: %{value: nil, error: []},
          state: %{value: nil, error: []},
          valid: false
        },
        result1: []
      )

    {:ok, socket}
  end

  def handle_event("form1", params, socket) do
    socket = update_values(socket, params)

    case socket.assigns.form1.valid do
      true ->
        subtotal = socket.assigns.form1.order.value

        if Enum.any?(@wisconsin, fn x ->
             String.downcase(socket.assigns.form1.state.value) == x
           end) do
          tax = subtotal * 5.5 / 100
          result = "The tax is #{tax} <br/> The total is #{tax + subtotal}"
          {:noreply, assign(socket, result1: result)}
        end

        result = "The total is #{subtotal}"
        {:noreply, assign(socket, result1: result)}

      false ->
        {:noreply, socket}
    end
  end

  defp update_values(socket, %{
         "order" => order,
         "state" => state
       }) do
    order = validate_integer(order)
    state = validate_string(state)

    valid =
      [order.error, state.error]
      |> Enum.all?(fn list -> list == [] end)

    assign(socket,
      form1: %{
        valid: valid,
        order: order,
        state: state
      }
    )
  end

  def validate_integer(string) do
    case Integer.parse(string) do
      {int, ""} when int > 0 -> %{value: int, error: []}
      {_, ""} -> %{value: string, error: ["0 또는 음수 값이 입력되었습니다."]}
      _ -> %{value: string, error: ["숫자가 아닌 값이 입력되었습니다."]}
    end
  end

  def validate_string(string) do
    %{value: string, error: []}
  end
end
