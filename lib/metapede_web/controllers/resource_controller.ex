defmodule MetapedeWeb.Controllers.ResourceController do
  use Phoenix.Controller

  def index(conn, _options) do
    IO.puts("""
    Verb: #{inspect(conn.method)}
    Host: #{inspect(conn.host)}
    Headers: #{inspect(conn.req_headers)}
    """)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end
