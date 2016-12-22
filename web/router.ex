defmodule HelloPhoenix.Router do
  use HelloPhoenix.Web, :router
  use HelloPhoenix.Web, :common

  import HelloPhoenix.Util.StringUtil


  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

#  pipeline :review_checks do
#    plug :ensure_authenticated_user
#	plug :ensure_user_owns_review
#  end

  def auth_plug(conn, _options \\ []) do
    query_params = fetch_query_params(conn).query_params
    IO.puts("query_params: #{inspect query_params}")

    token = Map.get(query_params, "token")
    if not is_nil_or_empty token do
      conn
    else
      conn |> api_err(401, "please login first")
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :auth_plug
  end





  scope "/", HelloPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/hello", HelloController, :index
	get "/hello/:messager", HelloController, :show
#	get "/", RootController, :index
    get "/test", PageController, :test

	resources "/users", UserController, except: [:index] do
	  resources "/porsts", PostController
	end
	resources "/reviews", ReviewController

    get "/copy_param_page", ParamController, :copy_param_page

    resources "/users", UserController
  end

  scope "/", HelloPhoenix do
    pipe_through :api
    get "/copy_param", ParamController, :copy_param
  end

  scope "/users", HelloPhoenix, as: :users do
    pipe_through :api
    post "/register", UserController, :register
    post "/login", UserController, :login
  end


  # Other scopes may use custom stacks.
  # scope "/api", HelloPhoenix do
  #   pipe_through [:api, :review_checks]
  # end

#  scope "/admin", HelloPhoenix.Admin, as: :admin do
#    resources "/reviews", ReviewController
#	resources "/images", ImageController
#  end
end