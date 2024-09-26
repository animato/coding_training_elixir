defmodule CodingTrainingElixirWeb.Chapter15Live do
  @user_map %{"user1" => "abc$123", "user2" => "secret"}
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form1: %{
          password: %{value: nil, error: []},
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
        user = Enum.find(@user_map, fn {_k, v} -> v == socket.assigns.form1.password.value end)

        result =
          if user != nil do
            {username, _password} = user
            "#{username} 환영합니다!"
          else
            "암호가 틀렸습니다."
          end

        {:noreply, assign(socket, result1: result)}

      false ->
        {:noreply, socket}
    end
  end

  defp update_values(socket, %{
         "password" => password
       }) do
    password = validate_string(password)

    valid =
      [password.error]
      |> Enum.all?(fn list -> list == [] end)

    assign(socket,
      form1: %{
        valid: valid,
        password: password
      }
    )
  end

  def validate_string(string) do
    %{value: string, error: []}
  end
end
