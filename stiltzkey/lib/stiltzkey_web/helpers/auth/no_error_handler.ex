defmodule StiltzkeyWeb.Helpers.Auth.NoErrorHandler do
  @moduledoc false

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
  end
end
