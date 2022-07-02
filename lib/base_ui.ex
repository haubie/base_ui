defmodule BaseUI do
 @moduledoc """
  Documentation for `BaseUI`.
  """

  use Phoenix.Component
  alias Phoenix.HTML.Link
  alias BaseUI.Icons
  alias Phoenix.LiveView.JS

  @default_icon_size "w-6 h-6"
  @nav_items_padding_left "pl-5"

  def icon(assigns) do
    assigns =
      assigns
      |> assign_new(:size, fn -> @default_icon_size end)
      |> assign_new(:glyph, fn -> nil end)
      |> assign_new(:class, fn -> nil end)

      ~H"""
      <span class={[@size, @class]}>
        <%= if @glyph do %>
          <%= Icons.icon(@glyph, assigns) %>
        <% else %>
          <%= Icons.icon("puzzle", assigns) %>
        <% end %>
      </span>
      """
   end

  def h(assigns) do
    assigns = assigns |> assign_new(:size, fn -> "text-2xl" end)
    ~H"""
    <h2 class={["font-medium mt-3 mb-1 sm:my-6", @size]}><%= render_slot(@inner_block) %></h2>
    """
  end

  def btn(assigns) do
    ~H"""
    <button role="button" class="bg-gray-50 px-5 py-0.5 rounded text-xs font-light border border-gray-200 hover:bg-gray-200 hover:font-medium h-7 w-48"><%= render_slot(@inner_block) %> &#8250;</button>
    """
  end

  def toolbar_btn(assigns) do

    rest =
      assigns_to_attributes(assigns, [:type, :icon, :label, :click, :form, :icon_size, :menu, :primary, :common_css, :primary_css, :secondary_css])

    assigns =
      assigns
      |> assign_new(:type, fn -> "button" end)
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:label, fn -> "Button" end)
      |> assign_new(:click, fn -> nil end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:icon_size, fn -> "w-4 h-4" end)
      |> assign_new(:menu, fn -> false end)
      |> assign_new(:primary, fn -> nil end)
      |> assign_new(:common_css, fn -> "text-xs flex flex-col items-center justify-center px-0.5 py-1 bg-indigo-900 border border-indigo-900 h-14 hover:bg-white hover:text-indigo-900 focus:ring-4 focus:ring-pink-500 focus:ring-offset-2 focus:outline-none" end)
      |> assign_new(:primary_css, fn -> "text-white" end)
      |> assign_new(:secondary_css, fn -> "bg-opacity-10 text-indigo-900" end)
      |> assign_new(:width, fn -> "w-24" end)
      |> assign(:rest, rest)

    ~H"""
    <%= if !@menu do %>
    <button {@rest} type={@type} form={@form} class={["rounded-md", @width, @common_css, @primary || @secondary_css, !@primary || @primary_css ]}>
      <%= if @icon do %><.icon glyph={@icon} size={@icon_size} class="pr-3" /><% end %>
      <span><%= @label %></span>
    </button>
    <% else %>
      <%= toolbar_duo_btn(assigns) %>
    <% end %>
    """
  end

  def toolbar_duo_btn(assigns) do
    assigns =
      assigns
      |> assign_new(:type, fn -> "button" end)
      |> assign_new(:icon_size, fn -> "h-4 w-4" end)
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:inner_block, fn -> nil end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:menu, fn -> nil end)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:id, fn -> "flyout_#{:erlang.unique_integer([:positive])}" end)

    ~H"""
    <div class="relative flex flex-row">
        <button :on-click={@click} type={@type} form={@form} class={["rounded-l-md border-t border-b border-r-0", @width, @common_css, @primary || @secondary_css, !@primary || @primary_css ]}>
          <%= if @icon do %><.icon glyph={@icon} size={@icon_size} /><% end %>
          <%= if @label do %><span><%= @label %></span><% end %>
          <%= if @inner_block do %><span><%= render_slot(@inner_block) %></span><% end %>
        </button>

        <button phx-click={JS.toggle(to: "##{@id}", in: {"ease-out transition duration-100", "opacity-0 transform scale-90", "opacity-100 transform scale-100"}, out: {"transition ease-in duration-100", "opacity-100 transform scale-100", "opacity-0 transform scale-90"})} type="button" class={["text-sm rounded-r-md border-r border-t border-b w-7 group", @common_css, @primary || @secondary_css, !@primary || @primary_css ]}>
          <svg xmlns="http://www.w3.org/2000/svg" class="transition ease-in-out duration-150 transform group-hover:translate-y-1 group-active:translate-y-2" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </button>

        <%= if @menu do %>
          <.flyout id={@id}>
          <%= render_slot(@menu) %>
          </.flyout>
        <% end %>

    </div>
    """
  end

  def flyout(assigns) do
    assigns = assign_new(assigns, :position, fn -> "origin-top-right right-0 mt-16" end)
    ~H"""
    <div
        phx-click-away={JS.hide(to: "##{@id}", transition: {"transition ease-in duration-100", "opacity-100 transform scale-100", "opacity-0 transform scale-90"})}
        id={@id}
        style="display: none;"
        class={["z-40 absolute w-64 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 focus:outline-none", @position]} role="menu">
      <!-- Flyout to menu -->
      <div class="py-1" role="none">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def flyout_menu_item(assigns) do
    assigns =
      assigns
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:label, fn -> "Menu item link" end)
      |> assign_new(:href, fn -> nil end)
      |> assign_new(:shortcut, fn -> nil end)

    ~H"""
    <a href={@href} class="inline-flex items-center w-full px-4 py-2 text-sm text-indigo-900 hover:bg-indigo-900 hover:bg-opacity-10 hover:text-indigo-700 group" role="menuitem">
      <%= if @icon do %><.icon glyph={@icon} size="w-4" class="inline-block flex-none pr-3" /><% end %>
      <span class="flex-1 ml-3"><%= @label %></span>
      <%= if @shortcut do %><span class="flex-none text-xs py-0.5 px-1.5 rounded-full border-1 border-indigo-900 text-indigo-700 bg-indigo-50 group-hover:bg-white"><%= @shortcut %></span><% end %>
    </a>
    """
  end



  def backdrop(assigns) do
    assigns =
      assigns
      |> assign_new(:color, fn -> "bg-gray-500/75" end)
      |> assign_new(:id, fn -> "backdrop" end)

    ~H"""
    <div id={@id} class="fixed inset-0 overflow-y-auto z-10">
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">

        <div class="fixed inset-0" aria-hidden="true">
          <div class={["absolute inset-0 fade-in", @color]}></div>
        </div>

        <!-- This element is to trick the browser into centering the modal contents. -->
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <%= render_slot(@inner_block) %>

      </div>
    </div>
    """
  end

  def js_show_backdrop(js \\ %JS{}, selector \\ "#backdrop") do
    js
    |> JS.show(transition: {"ease-out duration-300", "opacity-0", "opacity-100"}, to: selector)
  end
  def js_hide_backdrop(js \\ %JS{}, selector \\ "#backdrop") do
    js
    |> JS.show(transition: {"ease-out duration-200", "opacity-100", "opacity-0"}, to: selector)
  end



  def onward_link(assigns) do
    assigns = assigns |> assign_new(:size, fn -> "text-md" end)
    ~H"""
    <a class={["group font-semibold hover:underline hover:decoration-blue-500 hover:decoration-2 hover:underline-offset-4", @size]} href="#"><%= render_slot(@inner_block) %> <span class="inline-block font-bold transition ease-in-out delay-150 group-hover:translate-x-0.5 group-hover:text-blue-500">&#x2192;</span></a>
    """
  end


  def spacer(assigns) do
    ~H"""
    <div class="h-12"></div>
    """
  end



  def toolbar(assigns) do
    assigns =
      assigns
      |> assign_new(:height, fn -> "h-[65px]" end)
      |> assign_new(:title, fn -> "Title" end)
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:icon_size, fn -> "h-6 w-6" end)
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:inner_block, fn -> nil end)

    ~H"""
    <!-- Toolbar-->
    <div class={[@height, "flex-none flex flex-row items-center justify-between px-6 bg-white bg-opacity-70 shadow-md", @class]}>
      <!-- Screen title -->
      <h1 class="text-xl text-indigo-900 font-brand flex flex-row items-center space-x-2">
        <%= if @icon do %><.icon size={@icon_size} glyph={@icon} /><% end %>
        <span><%= @title %></span>
      </h1>
      <!-- Actions -->
        <%= if @inner_block do %>
        <div class="flex flex-row items-center space-x-3">
          <%= render_slot(@inner_block) %>
        </div>
      <% end %>
    </div>
    """
  end

  def nav_bar(assigns) do

    # links = [
    #   %{label: "Nav item 1", href: "https://hexdocs.pm/phoenix/overview.html"},
    #   %{label: "Nav item 1", route: Routes.live_dashboard_path(@conn, :home)}
    # ]

    ~H"""
    <nav class="h-14 font-semibold">
        <ul class="flex flex-row space-x-12 items-center">
        <%= render_slot(@inner_block) %>
        </ul>
    </nav>
    """
  end

  def nav_side(assigns) do
    ~H"""
    <nav class="flex text-xs font-regular w-full">
        <ul class="flex flex-col w-full">
        <%= render_slot(@inner_block) %>
        </ul>
    </nav>
    """
  end

  def nav_link(assigns) do
    assigns =
      assigns
      |> assign_new(:active, fn -> false end)
      |> assign_new(:href, fn -> "#" end)
      |> assign_new(:label, fn -> "Link" end)
      |> assign_new(:icon, fn -> nil end)

    ~H"""
    <li class="h-14 justify-center items-center">



      <a href={@href} class={[nav_active_classes(assigns), "focus:ring-4 focus:ring-pink-500 focus:ring-offset-2 focus:outline-none"]}>
        <%= if @icon do %><span class="mr-3"><.icon glyph={@icon} size="h-6 w-6" /></span><% end %>
        <%= @label %>
      </a>
    </li>
    """
  end

  def nav_route(assigns) do
    assigns =
      assigns
      |> assign_new(:active, fn -> false end)
      |> assign_new(:label, fn -> "Link" end)
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:padding_left, fn -> @nav_items_padding_left end)


    ~H"""
    <li class="h-8 justify-center items-center group">
      <%= live_redirect to: @route, class: [@padding_left, nav_active_classes(assigns), "focus:ring-3 focus:ring-pink-500 focus:ring-offset-1 focus:outline-none"] do %>
        <%= if @icon do %><span class="mr-3"><.icon glyph={@icon} size="h-6 w-6" /></span><% end %>
        <%= @label %>
      <% end %>
    </li>
    """
  end


  defp nav_active_classes(assigns) do
    [
      "flex items-center group-hover:bg-indigo-900/10 group-hover:text-indigo-700 py-2 my-1",
      if(assigns.active, do: [" border-blue-600"], else: [" border-transparent"])
    ]
  end

  def nav_heading(assigns) do
    assigns =
      assigns
      |> assign_new(:label, fn -> "Heading" end)
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:padding_left, fn -> @nav_items_padding_left end)

    ~H"""
    <li class={[@padding_left, "text-xs font-semibold text-indigo-400 uppercase tracking-wider"]}>
        <%= if @icon do %><span class="mr-3"><.icon glyph={@icon} size="h-6 w-6" /></span><% end %>
        <%= @label %>
    </li>
    """
  end

  def nav_group(assigns) do
    assigns =
      assigns
      |> assign_new(:label, fn -> "Heading" end)
      |> assign_new(:icon, fn -> nil end)

    ~H"""
    <li class="justify-center items-center text-xs font-semibold text-indigo-400 uppercase tracking-wider mt-6">
        <.nav_heading label={@label} glyph={@icon} />
        <ul class="mb-6 flex flex-col">
          <%= render_slot(@inner_block) %>
        </ul>
    </li>
    """
  end


  def row(assigns) do
    assigns =
      assigns
      |> assign_new(:right, fn -> [] end)

    ~H"""
    <div class="flex flex-col sm:flex-row sm:items-center my-6">
      <div class="flex flex-row flex-1">
      <%= render_slot(@inner_block) %>
      </div>
      <div><%= render_slot(@right) %></div>
    </div>
    """
  end

  def grid(assigns) do
    ~H"""
    <div class="grid grid-flow-row grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-8 xl:gap-16">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def wide_grid(assigns) do
    ~H"""
    <div class="grid grid-flow-row grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8 2xl:gap-16">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def mini_card(assigns) do
    assigns =
      assigns
      |> assign_new(:title, fn -> "Card title" end)
      |> assign_new(:href, fn -> "#" end)
      |> assign_new(:action_label, fn -> "Learn more" end)
      |> assign_new(:src, fn -> false end)

    ~H"""
    <a class="max-w-2xl group transition ease-in-out delay-150 hover:scale-[1.03]" href={@href}>
      <%= if @src do %>
      <div class="relative bg-teal-600 rounded h-24">
        <img class="absolute object-cover w-full rounded h-24" src={@src}>
        <div class="absolute w-full h-24 bg-gradient-to-br from-blue-500 to-teal-500 opacity-60"></div>
      </div>
      <% else %>
      <div class="w-full h-1 md:h-1.5 bg-gradient-to-br from-blue-500 to-teal-500 rounded-t"></div>
      <% end %>
      <h3 class="text-xl font-medium mt-3 group-hover:underline group-hover:decoration-blue-500 group-hover:decoration-2 group-hover:underline-offset-4"><%= @title %></h3>
      <%= if @action_label do %>
      <div class="font-light mt-2 group-hover:font-medium"><%= @action_label %> <span class="inline-block transition group-hover:translate-x-0.5 group-hover:text-blue-500">&#x2192;</span></div>
      <% end %>
      </a>
    """
  end

  def rule(assigns) do
    ~H"""
    <hr class="w-full h-1.5 bg-gradient-to-br from-blue-500 to-teal-500 my-2" />
    """
  end

  def card(assigns) do
    assigns =
      assigns
      |> assign_new(:title, fn -> "Card title" end)
      |> assign_new(:href, fn -> "#" end)
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:action_label, fn -> "Learn more" end)
      |> assign_new(:src, fn -> false end)
      |> assign_new(:height, fn -> "h-80" end)
      |> assign_new(:inner_block, fn -> nil end)

    ~H"""
    <a class={["group transition ease-in-out delay-150 hover:scale-[1.03] border border-gray-200 rounded shadow-md flex flex-col", @height, @class]} href={@href}>
      <%= if @src do %>
      <div class="relative bg-teal-600 rounded h-32 flex-0">
        <img class="absolute object-cover w-full rounded h-32" src="https://images.unsplash.com/photo-1554629947-334ff61d85dc?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1024&h=1280&q=80">
        <div class="absolute w-full h-32 bg-gradient-to-br from-blue-500 to-teal-500 opacity-60"></div>
      </div>
      <% else %>
      <div class="w-full h-1 md:h-1.5 bg-gradient-to-br from-blue-500 to-teal-500 rounded-t"></div>
      <% end %>
      <h3 class="text-xl font-medium mt-3 group-hover:underline group-hover:decoration-blue-500 group-hover:decoration-2 group-hover:underline-offset-4 px-3"><%= @title %></h3>

      <%= if @inner_block do %>
        <p class="px-3 flex-1 inline-block mt-3"><%= render_slot(@inner_block) %></p>
      <% else %>
        <p class="px-3 flex-1 inline-block mt-3">Default para</p>
      <% end %>

      <%= if @action_label do %>
      <div class="font-light mt-2 group-hover:font-medium px-3 pb-3"><%= @action_label %> <span class="inline-block transition group-hover:translate-x-0.5 group-hover:text-blue-500">&#x2192;</span></div>
      <% end %>
    </a>
    """
  end

  def carousel(assigns) do
    assigns =
      assigns
      |> assign_new(:snap, fn -> "snap-start" end)
      |> assign_new(:item, fn -> [] end)

    ~H"""
    <div class="overflow-hidden">
      <ol class="carousel">
          <%= for {item, index} <- Enum.with_index(@item) do %>
            <li id={"item_#{index+1}"} class={["shrink-0", @snap, class_for(item)]}>
              <%= render_slot(item) %>
            </li>
          <% end %>
      </ol>
      <ol class="w-full flex gap-6 justify-center mt-3">
        <%= for {_item, index} <- Enum.with_index(@item) do %>
          <li><button type="button" onclick={"baseui.scrollCarousel('item_#{index+1}')"} class="carousel-pagination"><%= index+1 %></button></li>
        <% end %>
      </ol>
    </div>
    """
  end


  def overlayed_image(assigns) do
    assigns =
      assigns
      |> assign_new(:color, fn -> "bg-gradient-to-br from-blue-500 to-teal-500" end)
      |> assign_new(:opacity, fn -> "opacity-60" end)
      |> assign_new(:height, fn -> "" end)
      |> assign_new(:width, fn -> "" end)
      |> assign_new(:fit, fn -> "object-cover" end)
      |> assign_new(:src, fn -> "https://images.unsplash.com/photo-1554629947-334ff61d85dc?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1024&h=1280&q=80" end)

    ~H"""
      <div class={["relative bg-gray-200 rounded flex-0", @height, @width]}>
        <img class={["absolute w-full rounded", @height, @width, @fit]} src={@src}>
        <div class={["absolute w-full", @color, @opacity, @height, @width]}></div>
      </div>
    """
  end

  def avatar(assigns) do
    # TO DO: implement image and icon and status badge
    # e.g. <.avatar alt="Remy Sharp" src="/static/images/avatar/1.jpg" />
    assigns =
      assigns
      |> assign_new(:color, fn -> "bg-indigo-900 text-white" end)
      |> assign_new(:text, fn -> nil end)
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:border, fn -> "border-b border-gray-300" end)
      |> assign_new(:size, fn -> "w-8 h-8 text-sm" end)
      |> assign_new(:src, fn -> nil end)
      |> assign_new(:inner_block, fn -> nil end)

    ~H"""
    <a class={["rounded-full flex flex-row justify-center items-center", @color, @icon, @border, @size]}>
    <%= @text %><%= if @inner_block, do: render_slot(@inner_block) %>
    </a>
    """
  end


  def table(assigns) do
    assigns =
      assigns
      |> assign_new(:width, fn -> "w-full" end)
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:col, fn -> [] end)
      |> assign_new(:rows, fn -> [] end)

    ~H"""
    <table class={["border border-gray-300 divide-y divide-gray-200 text-indigo-900", @width, @class]}>
          <thead class="bg-white">
            <tr class="h-8 align-middle">
            <%= for col <- @ col do %>
                <th scope="col" class="px-3 pt-1 text-left text-sm font-semibold text-indigo-400 uppercase tracking-wider">
                  <%= col.label %>
                </th>
            <% end %>
            </tr>
          </thead>

          <tbody class="bg-white divide-y divide-gray-200">

            <%= for {row, row_index} <- Enum.with_index(@rows) do %>
              <tr class={["h-20", table_row_formatter(row_index)]}>
                <%= for col <- @col do %>
                  <td class="px-3 whitespace-normal lg:whitespace-nowrap">
                    <div class="inline-flex flex-col">
                      <%= render_slot(col, row) %>
                    </div>
                  </td>
                <% end %>
              </tr>
            <% end %>

          </tbody>

      </table>
    """
  end

  defp table_row_formatter(index) do
    if Integer.mod(index, 2) == 1, do: "bg-indigo-100/20"
  end



  def modal(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:icon_color, fn -> "bg-indigo-100 text-indigo-900" end)
      |> assign_new(:title, fn -> "Modal title" end)
      |> assign_new(:title_color, fn -> "text-indigo-900" end)
      |> assign_new(:message, fn -> "Modal message" end)
      |> assign_new(:target, fn -> nil end)
      |> assign_new(:id, fn -> :erlang.unique_integer([:positive]) end)
      |> assign_new(:footer, fn -> nil end)
      |> assign_new(:type, fn -> nil end)
      |> assign_new(:icon_class, fn -> nil end)
      |> assign_new(:"phx-click-away", fn -> nil end)
      |> assign_new(:"phx-target", fn -> nil end)

    ~H"""
    <div
          id={"modal_#{@id}"}
          class={
            ["inline-block bg-white rounded-md text-left overflow-hidden shadow-xl transform transition-all sm:my-8 align-middle w-full sm:max-w-lg",
            @class]
          }
          role="dialog"
          aria-modal="true"
          aria-labelledby="modal-headline"
          tabindex="-1"
          phx-click-away={assigns."phx-click-away"}
          phx-target={assigns."phx-target"}
        >
          <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <div class="sm:flex sm:items-start mr-0 sm:mr-3">

              <%= if @icon do %>
              <div
                class={["mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 sm:mr-4 rounded-full sm:mx-0 sm:h-10 sm:w-10", @icon_color]}
              >
                <.icon glyph={@icon} w="w-6" h="h-6" />
              </div>
              <% end %>

              <div class="mt-3 text-center sm:mt-0 sm:text-left w-full">
                <h3 tabindex="-1" class={["text-lg font-semibold leading-6 font-medium", @title_color]} id="modal-headline">
                  <%= @title %>
                </h3>

                <div class="mt-2 w-full text-sm text-gray-500">
                <%= if @message do %>
                  <p>
                    <%= @message %>
                  </p>
                <% end %>
                <%= if @inner_block do %>
                  <div class="w-full max-h-96 overflow-auto overscroll-contain text-left">
                    <%= render_slot(@inner_block) %>
                  </div>
                <% end %>
                </div>
              </div>
            </div>
          </div>

          <%= if @footer do %>
            <div class="bg-gray-50 px-4 py-3 sm:px-6 flex flex-row-reverse space-x-reverse space-x-3">
              <%= render_slot(@footer) %>
            </div>
          <% end %>
        </div>
    """
  end

  def js_show_modal(js \\ %JS{}, selector \\ "#modal") do
    js
    |> JS.show(transition: {"ease-out duration-300", "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95", "opacity-100 translate-y-0 sm:scale-100"}, to: selector)
  end
  def js_hide_modal(js \\ %JS{}, selector \\ "#modal") do
    js
    |> JS.show(transition: {"ease-out duration-200", "opacity-100 translate-y-0 sm:scale-100", "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}, to: selector)
  end

  ## Helpers

  defp class_for(item), do: Map.get(item, :class, nil)

end
