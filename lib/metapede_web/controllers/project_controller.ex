defmodule MetapedeWeb.Controllers.ProjectController do
  use Phoenix.Controller

  def show(conn, _options) do
    IO.inspect(conn, label: "my_stuff")

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end

  # def create(conn, _opts) do
  # end

  # def update(conn, _opts) do
  # end

  # def delete(conn, _opts) do
  # end

end
