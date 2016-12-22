defmodule HelloPhoenix.ParamController do

  use HelloPhoenix.Web, :controller

  @moduledoc false

  def copy_param(conn, param) do
#    json conn, %{haha: "hehe"}
#    json conn, param
     render conn, "param.json", param
  end

  def copy_param_page(conn, param) do

    conn
    |> put_flash(:info, "Welcome to Phoenix, from flash info!")
    |> put_flash(:error, "Let's pretend we have an error.")
    |> render("show_param.html", param: param)

  end
  
end