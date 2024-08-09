defmodule CodingTrainingElixirWeb.Chapter5Live do
  use CodingTrainingElixirWeb, :live_view

  # 출력 예
  # What is the first number? 10 What is the second number? 5 10 + 5 = 15
  # 10 - 5 = 5
  # 10 * 5 = 50 10 / 5 = 2
  # 제약 조건
  # ·문자열로 입력 받도록 할 것. 이렇게 받은 문자열 값은 사칙연산을 하기 전에 숫자 값으로 변환시켜야 한다.
  # · 입력 값과 출력 값 모두 숫자 변환 및 기타 프로세스에 영향을 받지 않도록 할 것
  # · 한 개의 출력문만 사용하여 적당한 위치에 줄바꿈 글자를 넣을 것
  # 도전 과제
  # · 숫자만 입력되도록 프로그램을 수정해보자. 숫자가 아닌 값이 입력 된 경우 진행되면 안 된다.
  # · 음수를 넣을 수 없도록 하라.
  # · 계산 부분을 함수로 구현해보자. 함수에 대해서는 5장 ‘함수’에서 확
  # 인할 수 있다.
  # · 앞의 프로그램을 GUI로 구현하여 숫자를 넣는 즉시 자동으로 계산
  # 결과가 업데이트되도록 하라.

  def mount(_params, session, socket) do
    socket = assign(socket, result: "")
    {:ok, socket}
  end

  def handle_event("input-change", %{"number1" => number1, "number2" => number2}, socket) do
    valid = number1 != "" and number2 != ""

    if valid do
      n1 = String.to_integer(number1)
      n2 = String.to_integer(number2)
      plus = number1 <> " + " <> number2 <> " = " <> Integer.to_string(n1 + n2)
      minus = number1 <> " - " <> number2 <> " = " <> Integer.to_string(n1 - n2)
      multi = number1 <> " * " <> number2 <> " = " <> Integer.to_string(n1 * n2)
      divide = number1 <> " / " <> number2 <> " = " <> Float.to_string(n1 / n2)
      result = plus <> "<br/>" <> minus <> "<br/>" <> multi <> "<br/>" <> divide
      IO.puts(result)
      socket = assign(socket, result: result)
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end
end
