defmodule HelloPhoenix.UserController do
  use HelloPhoenix.Web, :controller
  use HelloPhoenix.Web, :common

  alias HelloPhoenix.User
  alias HelloPhoenix.Util.PasswordUtil
  alias HelloPhoenix.Util.StringUtil
  alias HelloPhoenix.Common.Redis.RedisClient
  alias HelloPhoenix.UserRoom
  alias HelloPhoenix.Room

#  def index(conn, _params) do
#    users = Repo.all(User)
#    conn |> api_suc(200, Enum.map(users, &(User.to_dict(&1))))
#  end
#
#  def new(conn, _params) do
#    changeset = User.changeset(%User{})
#    render(conn, "new.html", changeset: changeset)
#  end
#
#  def create(conn, %{"user" => user_params}) do
#    changeset = User.changeset(%User{}, user_params)
#
#    case Repo.insert(changeset) do
#      {:ok, _user} ->
#        conn
#        |> put_flash(:info, "User created successfully.")
#        |> redirect(to: user_path(conn, :index))
#      {:error, changeset} ->
#        render(conn, "new.html", changeset: changeset)
#    end
#  end
#
#  def show(conn, %{"id" => id}) do
#    user = Repo.get!(User, id)
#    render(conn, "show.html", user: user)
#  end
#
#  def edit(conn, %{"id" => id}) do
#    user = Repo.get!(User, id)
#    changeset = User.changeset(user)
#    render(conn, "edit.html", user: user, changeset: changeset)
#  end
#
#  def update(conn, %{"id" => id, "user" => user_params}) do
#    user = Repo.get!(User, id)
#    changeset = User.changeset(user, user_params)
#
#    case Repo.update(changeset) do
#      {:ok, user} ->
#        conn
#        |> put_flash(:info, "User updated successfully.")
#        |> redirect(to: user_path(conn, :show, user))
#      {:error, changeset} ->
#        render(conn, "edit.html", user: user, changeset: changeset)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    user = Repo.get!(User, id)
#
#    # Here we use delete! (with a bang) because we expect
#    # it to always work (and if it does not, it will raise).
#    Repo.delete!(user)
#
#    conn
#    |> put_flash(:info, "User deleted successfully.")
#    |> redirect(to: user_path(conn, :index))
#  end

# {username: "barton", email: "foo@gmail.com", password: "Passw0rd!"}
#{createdAt: "2015-12-30T15:17:05.379Z",
#   *   objectId: "5TgExo2wBA",
#   *   sessionToken: "r:dEgdUkcs2ydMV9Y9mt8HcBrDM"}
#   *
#}
  def register(conn, %{"username" => user_name, "email" => email, "password" => password } = _params) do

    salt = PasswordUtil.generate_salt
    pwd = PasswordUtil.generate_password password, salt

    user_params = %{"name": user_name, "email": email, "password": pwd, "salt": salt}

    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        token = StringUtil.uuid
        RedisClient.run(~w(SET #{token} #{user.id}))
        conn
        |> api_suc(201,
          %{
            "createdAt": user.inserted_at,
            "userId": user.id,
            "sessionToken": token
          }
        )

      {:error, _changeset} ->
        conn
        |> api_err(400, "Something wrong happend")
    end
  end

#  {username: "barton", password: "Passw0rd!"}
#   * createdAt: "2015-12-30T15:29:36.611Z"
#   * updatedAt: "2015-12-30T16:08:50.419Z"
#   * objectId: "Z4yvP19OeL"
#   * email: "barton@foo.com"
#   * sessionToken: "r:Kt9wXIBWD0dNijNIq2u5rRllW"
#   * username: "barton"
#   *

  def login(conn, %{"username" => username, "password" => password} = _params) do
#    query = from u in User,
#        where: u.name == ^username,
#        select: u,
#        limit: 1
#
#    user = Repo.one(query)
#    first(query, nil)

    user = (from u in User, where: u.name == ^username, select: u) |> first |> Repo.one!

    input_pwd = PasswordUtil.generate_password(password, user.salt)
    if input_pwd == user.password do
        token = StringUtil.uuid
        RedisClient.run(~w(SET #{token} #{user.id}))
        api_suc(conn, 200,
          Map.put(User.to_dict(user), "sessionToken", token)
        )
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

  def user_rooms(conn, %{"user_id" => user_id}) do
    rooms = UserRoom.query_rooms_for_user(String.to_integer user_id)
    api_suc(conn, 200,
      Enum.map(rooms,
      &(Room.to_dict(&1)))
    )
  end

  def get_sms_validation_code(conn, %{"phoneNumber" => phone_number}) do
#    validate the phone number
#    generate a valiadation code
#    send the validation code to the phoneNumber by api
    case Phone.parse(phone_number) do
      {:ok, phone_map} ->
      IO.puts(inspect phone_map)
        validation_code = StringUtil.generate_random_alnum(4)
        RedisClient.run(~w(SET #{phone_number} #{validation_code}))
        api_suc(conn, 200, validation_code)
      {:error, "Not a valid phone number."} ->
        conn
        |> api_err(400, "Not a valid phone number.")
    end
  end


  def login_with_phone_number(conn, %{"phoneNumber" => phone_number, "validationCode" => validation_code}) do

    result =
      with {:ok, phone_map} <- Phone.parse(phone_number),
           {:ok} <- verify_code(phone_number, validation_code),
           {:ok, user} <- save_user(phone_number),
      do:  {:ok, user}

    case result do
      {:ok, user} ->
        token = StringUtil.uuid
        RedisClient.run(~w(SET #{token} #{user.id}))
        conn
        |> api_suc(200, Map.put(User.to_dict(user), "sessionToken", token))
      {:error, :code_validation_failed} ->
        conn
        |> api_err(400, "pls check your validation code")
      {:error, "Not a valid phone number."} ->
        conn
        |> api_err(400, "Not a valid phone number.")
      {:error, changeset} ->
        conn
        |> api_err(400, "Something wrong happend")
    end

  end

  defp verify_code(phone_number, code) do
    db_code = RedisClient.run(~w(GET #{phone_number}))
    if db_code == code do
      RedisClient.run(~w(DEL #{phone_number}))
      {:ok}
    else
      {:error, :code_validation_failed}
    end
  end

  defp save_user(phone_number) do
    db_user = User.query_by_phone_number(phone_number)
    if db_user == nil do
      user_params = %{"phone_number": phone_number}
      changeset = User.changeset(%User{}, user_params)
      Repo.insert(changeset)
    else
      {:ok, db_user}
    end
  end

end
