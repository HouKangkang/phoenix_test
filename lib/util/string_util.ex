defmodule HelloPhoenix.Util.StringUtil do

  @moduledoc false

  def generate_random_string(length) do
    :base64.encode(:crypto.strong_rand_bytes(length))
  end

  def uuid() do
     UUID.uuid4 ()
  end


  def is_nil_or_empty(s) do
    nil == s or "" == s
  end

end