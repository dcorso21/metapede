defmodule MetapedeWeb.TestApi do
  # import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    IO.puts("""
    Verb: #{inspect(conn.method)}
    Host: #{inspect(conn.host)}
    Headers: #{inspect(conn.req_headers)}
    """)

    conn
  end
end
