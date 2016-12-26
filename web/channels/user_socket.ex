defmodule HelloPhoenix.UserSocket do
  use Phoenix.Socket
  import HelloPhoenix.Util.StringUtil

  alias HelloPhoenix.Common.Redis.RedisClient

  ## Channels
  channel "room:*", HelloPhoenix.RoomChannel
  channel "users_socket:*", HelloPhoenix.UserChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(params, socket) do
    IO.puts("socket params: #{inspect params}")
    token = params["token"]
#    user_id = RedisClient.run(~w"GET #{token}")
    user_id = token
    if not is_nil_or_empty user_id do
      IO.puts("assign user_id to socket: #{user_id}")
      {:ok, assign(socket, :user_id, user_id)}
    else
      {:error}
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     HelloPhoenix.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
#  def id(socket), do: "users_socket:1"

end
