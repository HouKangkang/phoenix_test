defmodule HelloPhoenix.MessageController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.Message

#  def index(conn, _params) do
#    messages = Repo.all(Message)
#    render(conn, "index.json", messages: messages)
#  end
#
#  def create(conn, %{"message" => message_params}) do
#    changeset = Message.changeset(%Message{}, message_params)
#
#    case Repo.insert(changeset) do
#      {:ok, message} ->
#        conn
#        |> put_status(:created)
#        |> put_resp_header("location", message_path(conn, :show, message))
#        |> render("show.json", message: message)
#      {:error, changeset} ->
#        conn
#        |> put_status(:unprocessable_entity)
#        |> render(HelloPhoenix.ChangesetView, "error.json", changeset: changeset)
#    end
#  end
#
#  def show(conn, %{"id" => id}) do
#    message = Repo.get!(Message, id)
#    render(conn, "show.json", message: message)
#  end
#
#  def update(conn, %{"id" => id, "message" => message_params}) do
#    message = Repo.get!(Message, id)
#    changeset = Message.changeset(message, message_params)
#
#    case Repo.update(changeset) do
#      {:ok, message} ->
#        render(conn, "show.json", message: message)
#      {:error, changeset} ->
#        conn
#        |> put_status(:unprocessable_entity)
#        |> render(HelloPhoenix.ChangesetView, "error.json", changeset: changeset)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    message = Repo.get!(Message, id)
#
#    # Here we use delete! (with a bang) because we expect
#    # it to always work (and if it does not, it will raise).
#    Repo.delete!(message)
#
#    send_resp(conn, :no_content, "")
#  end
end
