defmodule BaseUI.Layout do

  use Phoenix.Component
  alias Phoenix.HTML.Link

  def app_layout(assigns) do
    assigns =
      assigns
      |> assign_new(:inner_block, fn -> nil end)
      |> assign_new(:header, fn -> nil end)
      |> assign_new(:left, fn -> nil end)
      |> assign_new(:class, fn -> nil end)

    ~H"""
    <div class="h-screen w-screen flex flex-col overflow-hidden">
      <div class={["flex flex-row flex-none w-full border-b border-gray-300 items-center justify-between", get_class_for_single_slot(@header, "h-20")]}>
        <%= render_slot(@header) %>
      </div>
      <div class="flex-grow flex flex-row overflow-hidden">
        <div class={["flex-none flex flex-col justify-between border-r border-gray-300 overflow-y-auto", get_class_for_single_slot(@left, "w-[225px]")]}>
          <%= render_slot(@left) %>
        </div>
        <main class={["flex-1 flex flex-col", @class]}>
          <%= render_slot(@inner_block) %>
        </main>
      </div>

    </div>
    """
  end

  defp get_class_for_single_slot(slot, default \\ "") do
    slot
    |> List.first()
    |> Map.get(:class, default)
  end

end
