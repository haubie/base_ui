defmodule BaseUI.LiveModal do

  use Phoenix.LiveComponent

  ## ####################
  ## Public API
  ## ####################

  def show(id), do: send_update(__MODULE__, id: id, show: true)
  def hide(id), do: send_update(__MODULE__, id: id, show: nil)

  ## ####################
  ## Update
  ## ####################

  def update(assigns, socket) do

    show    = assigns[:show]    || false
    title   = assigns[:title]   || "Modal title"
    message = assigns[:message] || nil
    icon    = assigns[:icon]    || nil
    id      = assigns[:id]      || "modal"
    click   = assigns[:"phx-click"] || nil
    value   = assigns[:value]   || nil
    target   = assigns[:target] || nil

    IO.inspect assigns |> Map.keys(), label: "Assign keys"


    assign_keys = Map.keys(assigns)
    modal_type =
      cond do
        :simple in assign_keys -> [modal_type: :simple, icon: icon || "info", icon_color: "bg-indigo-800 text-white opacity-80", title_color: "text-indigo-900", button_text: (assigns[:button_text] || "Close")]
        :action in assign_keys -> [modal_type: :action, icon: icon || "click", icon_color: "bg-green-600 text-white opacity-80", title_color: "text-green-600", button_text: (assigns[:button_text] || "Yes")]
        :delete in assign_keys -> [modal_type: :delete, icon: icon || "warning", icon_color: "bg-red-600 text-white opacity-80", title_color: "text-red-600", button_text: (assigns[:button_text] || "Delete")]
        true -> [modal_type: :simple, icon: icon, icon_color: "bg-indigo-900 text-white opacity-70", title_color: "text-indigo-900", button_text: (assigns[:button_text] || "Close")]
      end

    {:ok, assign(socket, [show: show, id: id, title: title, message: message, click: click, value: value, target: target] ++ modal_type)}
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

  def render(assigns) do
  ~H"""
  <div id={@id}>
    <%= if @show do %>
      <BaseUI.backdrop>
        <BaseUI.modal target={@myself} class="fade-in-scale" type={@modal_type} icon={@icon} icon_color={@icon_color} title_color={@title_color} title={@title} message={@message}>

        <:footer>
          <%= if @modal_type == :simple do %>
            <button type="button" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 hover:border-purple-900 hover:text-purple-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
                    phx-click="hide-modal" phx-target={@target || @myself} phx-value-action-data={@value}>
              <%= @button_text %>
            </button>
          <% end %>

          <%= if @modal_type == :action do %>
            <button type="button" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-green-600 text-base font-medium text-white hover:bg-green-700 hover:border-green-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500 sm:ml-3 sm:w-auto sm:text-sm"
                    phx-click={@click} phx-value-action-data={@value}>
              <%= @button_text %>
            </button>
            <button type="button" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 hover:border-green-900 hover:text-green-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
                    phx-click="hide-modal" phx-target={@myself}>
              Cancel
            </button>
        <% end %>

        <%= if @modal_type == :delete do %>
          <button type="button" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 hover:border-red-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm"
                  phx-click={@click} phx-value-action-data={@value}>
            <%= @button_text %>
          </button>
          <button type="button" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 hover:border-red-900 hover:text-red-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
                  phx-click="hide-modal" phx-target={@myself}>
            Cancel
          </button>
          <% end %>
        </:footer>

        </BaseUI.modal>
      </BaseUI.backdrop>
    <% end %>
  </div>
  """
  end
end
