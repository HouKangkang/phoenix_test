defmodule HelloPhoenix.UserController do
  use HelloPhoenix.Web, :controller
  use HelloPhoenix.Web, :common

  alias HelloPhoenix.User
  alias HelloPhoenix.Util.PasswordUtil
  alias HelloPhoenix.Util.StringUtil
  alias HelloPhoenix.Common.Redis.RedisClient

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  def register(conn, %{"user" => user_params}) do

    salt = PasswordUtil.generate_salt
    pwd = PasswordUtil.generate_password user_params["password"], salt

    user_params = Map.merge(
            user_params,
            %{"password" => pwd, "salt" => salt},
            fn _, _, new_value -> new_value end)

    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} -> conn |> api_suc(201, User.to_dict(user))
      {:error, _changeset} -> conn |> api_err(400, "Something wrong happend")
    end
  end

  def login(conn, %{"username" => username, "password" => password} = _params) do
    query = from u in "users", where: u.name == ^username, select: {u.id, u.name, u.password, u.salt}, limit: 1

    user = Repo.one(query)
#    first(query, nil)
#
#    user = query |> first |> Repo.one!

    input_pwd = PasswordUtil.generate_password(password, elem(user, 3))
    if input_pwd == elem(user, 2) do
        token = StringUtil.uuid
        RedisClient.run(~w(SET #{token} #{elem(user, 0)}))
        api_suc(conn, 200, %{"token": token, "userId": elem(user, 0), "name": elem(user, 1)})
    else
        api_err(conn, 400, "Access denied")
    end

  end


  def user_detail(conn, %{"user_id" => user_id}) do
    user = Repo.get(User, user_id)
    IO.puts inspect user
    api_suc(conn, 200, User.to_dict(user))
  end

  def logout(conn, %{"token" => token}) do
#    remove the token from cache
    RedisClient.run(~w(DEL #{token}))
    api_suc(conn, 200, "ok")
  end

end
