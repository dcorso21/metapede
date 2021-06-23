defmodule MetapedeWeb.TopicController do
  use MetapedeWeb, :controller
  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    live_render(conn, MetapedeWeb.TesterLive.Test,
      session: %{
        "hello" => "hi",
        "other" => "otherwords"
      }
    )
  end
end
