defmodule AuthApi.Domain.Model.Session.Gateway.SessionsRepository do
  @moduledoc """
  Behaviour for managing sessions.
  """

  @callback save(AuthApi.Domain.Model.Session.Model.Session.t()) :: :ok
  @callback find_by_user_id(String.t()) :: {:ok, AuthApi.Domain.Model.Session.Model.Session.t()} | {:error, :session_not_found}
end
