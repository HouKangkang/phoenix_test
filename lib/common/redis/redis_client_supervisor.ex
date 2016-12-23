defmodule HelloPhoenix.Common.Redis.RedisClientSupervisor do
  use Supervisor

  alias HelloPhoenix.Common.Redis.RedisClient

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(RedisClient, ["redis://localhost:6379", :redix], [])
    ]

    supervise(children, strategy: :one_for_one)
  end
  
end
