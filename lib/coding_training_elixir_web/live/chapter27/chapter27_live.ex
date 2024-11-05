defmodule CodingTrainingElixirWeb.Chapter27Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", "ko")
    Gettext.put_locale(CodingTrainingElixirWeb.Gettext, locale)

    socket =
      assign(socket,
        form: to_form(%{"firstName" => nil, "lastName" => nil}, errors: [])
      )

    {:ok, socket}
  end

  def handle_event("change", params, socket) do
    errors = validate_input(params)

    {:noreply,
     assign(socket,
       form: to_form(params, errors: errors)
     )}
  end

  def validate_input(params) do
    validate_map = %{
      "firstName" => fn x ->
        if (not_blank?(x) and String.length(x) >= 2) == false, do: "2글자 이상이어야 합니다.", else: ""
      end,
      "lastName" => fn x ->
        if (not_blank?(x) and String.length(x) >= 2) == false, do: "2글자 이상이어야 합니다."
      end,
      "zipCode" => fn x ->
        if numeric?(x) == false, do: "숫자여야 합니다."
      end,
      "employeeId" => fn x ->
        if valid_employee_id?(x) == false, do: "ID 형식이 잘못되었습니다."
      end
    }

    result =
      Enum.map(params, fn {key, value} ->
        validate = Map.get(validate_map, key, fn _ -> "" end)
        {String.to_atom(key), {validate.(value), []}}
      end)

    result
  end

  def not_blank?(string) when is_binary(string) do
    Regex.match?(~r/\S/, string)
  end

  def not_blank?(_), do: false

  def numeric?(string) when is_binary(string) do
    Regex.match?(~r/^\d+$/, string)
  end

  def numeric?(_), do: false

  def valid_employee_id?(string) when is_binary(string) do
    Regex.match?(~r/^[A-Z]{2}-[0-9]{4}$/, string)
  end

  def valid_employee_id?(_), do: false
end
