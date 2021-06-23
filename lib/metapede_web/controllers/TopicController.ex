defmodule MetapedeWeb.TopicController do
  use MetapedeWeb, :controller
  import Phoenix.LiveView.Controller

  def index(conn, p) do
    IO.puts("INSPECTION")
    IO.puts(inspect(p))

    live_render(conn, MetapedeWeb.TesterLive.Test,
      session: %{
        "hello" => "hi",
        "other" => "otherwords"
      }
    )
  end
end
