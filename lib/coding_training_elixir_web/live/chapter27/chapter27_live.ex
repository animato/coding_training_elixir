defmodule CodingTrainingElixirWeb.Chapter27Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", "ko")
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, locale)

    socket =
      assign(socket,
        form: to_form(%{}, errors: [])
      )

    {:ok, socket}
  end

  def handle_event("change", params, socket) do
    validate_input(params)

    {:noreply,
     assign(socket,
       form: to_form(params, errors: [])
     )}
  end

  def validate_input(params) do
    validate_map = %{
      "firstName" => fn x -> not_blank?(x) and String.length(x) >= 2 end,
      "lastName" => fn x -> not_blank?(x) and String.length(x) >= 2 end,
      "zipCode" => fn x -> is_numeric?(x) end,
      "employeeId" => fn x -> is_valid_employee_id?(x) end
    }

    Enum.each(params, fn {key, value} ->
      validate = Map.get(validate_map, key, fn _ -> true end)
      IO.puts("#{key} #{value} #{validate.(value)}")
    end)
  end

  def not_blank?(string) when is_binary(string) do
    Regex.match?(~r/\S/, string)
  end

  def not_blank?(_), do: false

  def is_numeric?(string) when is_binary(string) do
    Regex.match?(~r/^\d+$/, string)
  end

  def is_numeric?(_), do: false

  def is_valid_employee_id?(string) when is_binary(string) do
    Regex.match?(~r/^[A-Z]{2}-[0-9]{4}$/, string)
  end

  def is_valid_employee_id?(_), do: false
end
