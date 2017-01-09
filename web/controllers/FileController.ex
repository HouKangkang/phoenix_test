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
#    IO.inspect(get_orgin(conn.req_headers))
#    api_suc(conn, 201, "http://localhost:4000/uploads/" <> file_name)
#    api_suc(conn, 201, Enum.join([conn.scheme, "://", conn.host, ":", conn.port, "/uploads/", file_name], ""))
    api_suc(conn, 201, Enum.join([get_orgin(conn.req_headers), "/uploads/", file_name], ""))

#    IO.puts("url from connection: #{Router.Helpers.url(conn)}")
#    api_suc(conn, 201, Enum.join([Router.Helpers.url(conn), "/uploads/", file_name], ""))

  end

  defp get_orgin(headers) do
    item = Enum.find(headers, &(elem(&1,0) == "origin"))
    elem(item, 1)
  end

end