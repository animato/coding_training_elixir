defmodule CodingTrainingElixirWeb.MyComponents do
  @moduledoc """
  메인 페이지 챕터 링크 모듈
  """
  use Phoenix.Component
  import CodingTrainingElixirWeb.CoreComponents

  attr :href, :string, required: true
  attr :icon_name, :string, default: ""
  slot :inner_block, required: true

  def chapter(assigns) do
    ~H"""
    <.link
      href={@href}
      class="group relative rounded-2xl px-6 py-4 text-sm font-semibold leading-6 text-zinc-900 sm:py-6"
    >
      <span class="absolute inset-0 rounded-2xl bg-zinc-50 transition group-hover:bg-zinc-100 sm:group-hover:scale-105">
      </span>
      <span class="relative flex items-center gap-4 sm:flex-col">
        <.icon :if={@icon_name != ""} name={@icon_name} /> <%= render_slot(@inner_block) %>
      </span>
    </.link>
    """
  end
end
