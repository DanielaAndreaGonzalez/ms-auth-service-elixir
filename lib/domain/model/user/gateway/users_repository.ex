defmodule AuthApi.Domain.Model.User.Gateway.UsersRepository do
  @moduledoc """
  Behaviour for reading users.
  """

  @callback find_by_email(String.t()) :: {:ok, AuthApi.Domain.Model.User.Model.User.t()} | {:error, :user_not_found}
end
