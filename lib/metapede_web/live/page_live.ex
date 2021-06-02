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
      <form phx-submit=""></form>
    """
  end

  def handle_event("say_hi", _, socket) do
    IO.puts("Hi There")
    socket = assign(socket, hhh: "Hellooooo")
    {:noreply, socket}
  end
end
