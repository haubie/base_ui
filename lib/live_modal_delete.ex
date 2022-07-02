defmodule BaseUI.LiveModalDelete do

  use Phoenix.LiveComponent

  ## ####################
  ## Public API
  ## ####################

  def show(id), do: send_update(__MODULE__, id: id, show: true)
  def show(id, data), do: send_update(__MODULE__, id: id, show: true, value: data)
  def hide(id), do: send_update(__MODULE__, id: id, show: false)

  ## ####################
  ## Mount
  ## ####################

  @impl true
  def mount(socket) do
    IO.inspect socket, label: "LiveModalDelete"
    {:ok, socket |> assign(show: false, icon: "warning")}
  end

  ## ####################
  ## Update
  ## ####################

  @impl true
  def update(assigns, socket) do

    title   = assigns[:title]   || "Modal title"
    message = assigns[:message] || nil
    icon    = assigns[:icon] || socket.assigns[:icon]
    IO.inspect icon, label: "ICON"
    id      = assigns[:id]    || "modal"
    click   = assigns[:click] || socket.assigns[:click] || "delete-action"
    value   = assigns[:value] || nil
    # target   = assigns[:target] || nil
    inner_block  = assigns[:inner_block] || socket.assigns[:inner_block]

    # assign_keys = Map.keys(assigns)
    # modal_type = [modal_type: :delete, icon: icon || "warning", icon_color: "bg-red-600 text-white opacity-80", title_color: "text-red-600", button_text: (assigns[:button_text] || "Delete")]

    # socket = assign(socket, [show: show, id: id, title: title, message: message, click: click, value: value, target: target, inner_block: inner_block] ++ modal_type)
    # IO.inspect socket, label: "Socket"
    # {
    #   :ok,
    #   socket
    #   |> assign(id: id, show: show, title: title, message: message, click: click, inner_block: inner_block, value: value)
    #   |> assign(button_text: (assigns[:button_text] || "Delete"))
    # }

    {:ok,
      socket
      |> assign(assigns)
      |> assign(value: value)
    }
  end

  ## ####################
  ## Callback
  ## ####################

  def handle_event("hide-modal", _data, socket) do
    {:noreply, socket |> assign(show: false)}
  end

  def handle_event("show-modal", _data, socket) do
    {:noreply, socket |> assign(show: true)}
  end

  ## ####################
  ## Template
  ## ####################

  @impl true
  def render(assigns) do
  ~H"""
  <div id={@id}>
    <%= if @show do %>
      <BaseUI.backdrop>
        <BaseUI.modal class="fade-in-scale" type={:delete} icon={@icon} icon_color="bg-red-600 text-white opacity-80" title_color="text-red-600" title={@title} message={@message} phx-click-away="hide-modal" phx-target={@myself}>

        <%= if @inner_block do %>
          <%= render_slot(@inner_block) %>
        <% end %>

          <:footer>

            <button type="button" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 hover:border-red-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm"
              phx-click={@click} phx-value-action-data={@value} >
              <%= @button_text %>
            </button>
            <button type="button" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 hover:border-red-900 hover:text-red-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
                    phx-click="hide-modal" phx-target={@myself}>
              Cancel
            </button>

          </:footer>

      </BaseUI.modal>
    </BaseUI.backdrop>
    <% end %>
  </div>
  """
  end
end
