defmodule HelloPhoenix.Util.StringUtil do

  @moduledoc false

  def generate_random_string(length) do
    :base64.encode(:crypto.strong_rand_bytes(length))
  end

  def uuid() do
     UUID.uuid4()
  end

  def generate_random_alnum(length) do
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    chars_size = String.length(chars)
#    f = fn(_item, r) -> [String.at(chars, Enum.random(0..(chars_size - 1))) | r] end

#    Enum.join(:lists.foldl(f, [], :lists.seq(1, length)), "")
    Enum.join(
      Enum.map(
        1..length,
        fn _ -> String.at(chars, Enum.random(0..(chars_size - 1))) end
      ),
    "")
  end


  def is_nil_or_empty(s) do
    nil == s or "" == s
  end

end