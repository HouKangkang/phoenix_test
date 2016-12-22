defmodule HelloPhoenix.Util.PasswordUtil do

  @moduledoc false

  @default_salt_length 10

  import HelloPhoenix.Util.StringUtil

  def generate_salt(length \\ @default_salt_length) do
    generate_random_string length
  end

  def generate_password(plain_pwd, salt) do
    :base64.encode :crypto.hmac(:md5, salt, plain_pwd)
  end

end