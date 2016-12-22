defmodule HelloPhoenix.PageController do
  use HelloPhoenix.Web, :controller

  def index(conn, _params) do
    conn
    |> put_flash(:info, "Welcome to Phoenix, from flash info!")
    |> put_flash(:error, "Let's pretend we have an error.")
    |> render("index.html")
  end

  def test(conn, _params) do
    render conn, "test.html"
  end

end
