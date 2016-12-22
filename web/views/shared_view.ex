defmodule HelloPhoenix.SharedView do

  use HelloPhoenix.Web, :view
  @moduledoc false


  def render("shared.json", params) do
    %{
      "statusCode" => params["code"],
      "err" => params["err"],
      "data" => params["data"]
      }
  end
  
end