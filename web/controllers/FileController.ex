defmodule HelloPhoenix.FileController do

  use HelloPhoenix.Web, :controller
  use HelloPhoenix.Web, :common

  alias HelloPhoenix.Util.StringUtil
  alias HelloPhoenix.Router

  def upload(conn, %{"file" => file}) do
    IO.inspect(conn)
#    IO.inspect(file)
    extension = Path.extname(file.filename)
    random_file_name = StringUtil.uuid
    file_name = random_file_name <> extension

    File.cp(file.path, "/tmp/" <> file_name)
#    api_suc(conn, 201, "http://localhost:4000/uploads/" <> file_name)
#    api_suc(conn, 201, Enum.join(["http://", conn.host, ":", conn.port, "/uploads/", file_name], ""))
    api_suc(conn, 201, Enum.join([Router.Helpers.url(conn), "/uploads/", file_name], ""))

  end

end