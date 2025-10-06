defmodule AuthApi.Domain.Model.User.Gateway.UsersWriter do
  @moduledoc """
  Behaviour for writing users.
  """

  @callback save(AuthApi.Domain.Model.User.Model.User.t()) :: :ok | {:error, :email_already_exists}
end
