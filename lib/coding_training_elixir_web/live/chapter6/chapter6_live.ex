defmodule CodingTrainingElixirWeb.Chapter6Live do
  use CodingTrainingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, result: "결과가 여기에 나타납니다")
    {:ok, socket}
  end

  def handle_event("input-change", %{"age" => age, "retire" => retire}, socket) do
    case valid(age, retire) do
      {:ok, {n1, n2}} ->
        {:ok, r} = calc(n1, n2)
        result = print(r.remain_age, r.year, r.retire_year)
        socket = assign(socket, result: result)
        {:noreply, socket}

      {:error, msg} ->
        IO.inspect(msg)
        socket = assign(socket, result: msg)
        {:noreply, socket}
    end
  end

  def print(remain_age, year, retire_year) do
    "당신은 은퇴하려면 #{remain_age}년이 남았습니다.<br/> 올해는 #{year}년이어서 당신은 #{retire_year}에 은퇴할 수 있습니다."
  end

  def calc(age, retire) do
    remain_age = retire - age
    {:ok, datetime} = DateTime.now("Asia/Seoul", Tzdata.TimeZoneDatabase)
    year = datetime.year
    retire_year = year + remain_age
    {:ok, %{remain_age: remain_age, year: year, retire_year: retire_year}}
  end

  def valid(age_input, retire_input) do
    with {age, ""} <- Integer.parse(age_input),
         {retire, ""} <- Integer.parse(retire_input),
         true <- age > 0,
         true <- retire > 0,
         :ok <- is_after_retire(age, retire) do
      {:ok, {age, retire}}
    else
      :error -> {:error, "숫자가 아닌 값이 입력되었습니다."}
      :after_retire -> {:error, "은퇴 나이가 지났습니다."}
      _ -> {:error, "0 또는 음수 값 입력되었습니다."}
    end
  end

  def is_after_retire(age, retire) when age <= retire, do: :ok
  def is_after_retire(_, _), do: :after_retire
end
