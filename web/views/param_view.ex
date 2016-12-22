defmodule HelloPhoenix.ParamView do
  use HelloPhoenix.Web, :view

  def render("param.json", param) do
    %{name: param["name"], age: param["age"]}
  end

end
