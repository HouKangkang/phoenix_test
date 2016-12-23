defmodule HelloPhoenix.Common.Redis.RedisClient do
  @moduledoc false

  def start_link(connection, name) do
    Redix.start_link(connection, name: name)
  end

  def run(param) do
    case Redix.command(:redix, param) do
      {:ok, result} -> result
      _ -> nil
    end
  end
  
end