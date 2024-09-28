defmodule CodingTrainingElixirWeb.Chapter15Live do
  @user_map %{
    # abc$123
    "user1" => "$2b$12$KGFZVTQCIdp.Dg1L7hgi7.uVWiNed2Ar6/ApfsNrqMWFh8QwI0fj2",
    # secret
    "user2" => "$2b$12$Ax1XUg9Vg7fMWM.UCYxXKeaJgmKVHcryhbQ/buF8Ekoi.x3YyoeFS"
  }
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, form: to_form(%{"password" => nil}))
    {:ok, socket}
  end

  def handle_event("validate", %{"password" => password}, socket) do
    {:noreply, assign(socket, form: to_form(%{"password" => password}))}
  end

  def handle_event("save", %{"password" => password}, socket) do
    user =
      Enum.find(@user_map, fn {_k, v} ->
        Bcrypt.verify_pass(password, v)
      end)

    {result, message} =
      if user != nil do
        {username, _password} = user
        {:info, "#{username} 환영합니다!"}
      else
        {:error, "암호가 틀렸습니다."}
      end

    {:noreply,
     socket
     |> assign(form: to_form(%{"password" => nil}))
     |> put_flash(result, message)}
  end

  def validate_string(string) do
    %{value: string, error: []}
  end
end
