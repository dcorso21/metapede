defmodule MetapedeWeb.TestApi do
  use Phoenix.Controller

  def index(conn, _options) do
    IO.puts("""
    Verb: #{inspect(conn.method)}
    Host: #{inspect(conn.host)}
    Headers: #{inspect(conn.req_headers)}
    """)

    conn
  end
end
