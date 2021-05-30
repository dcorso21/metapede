defmodule MetapedeWeb.PageLive do
  use MetapedeWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(text: "Metapede")
      |> assign(hhh: nil)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1> <%= @text %> </h1>
      <p phx-click="say_hi">Hello</p>
      <div
        id="my-test"
        phx-hook="Testing">
      </div>
      <%= if @hhh do %>
        <p> <%= @hhh %> </p>
      <% end %>
    """
  end

  def handle_event("say_hi", _, socket) do
    IO.puts("Hi There")
    socket = assign(socket, hhh: "Hellooooo")
    {:noreply, socket}
  end
end
