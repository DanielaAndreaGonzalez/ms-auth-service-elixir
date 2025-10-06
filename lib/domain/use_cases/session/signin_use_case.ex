defmodule AuthApi.Domain.UseCases.Session.SigninUseCase do
  @moduledoc """
  Signin use case: handles user authentication and session creation.
  """

  alias AuthApi.Domain.Model.Session.SessionDto
  alias AuthApi.Domain.Model.Session.Model.Session
  alias AuthApi.Domain.Model.User.Gateway.UsersRepository
  alias AuthApi.Domain.Model.Session.Gateway.SessionsRepository

  @spec execute(SessionDto.t(), UsersRepository.t(), SessionsRepository.t()) :: {:ok, String.t()} | {:error, atom()}
  def execute(%SessionDto{email: email, password: password}, users_repository, sessions_repository) do
    with {:ok, user} <- users_repository.find_by_email(email),
         true <- password == AuthApi.Domain.Model.Shared.Common.Validate.Password.value(user.password) do
      session = Session.create(user.id)
      :ok = sessions_repository.save(session)
      {:ok, session.session_id}
    else
      {:error, :user_not_found} -> {:error, :user_not_found}
      false -> {:error, :invalid_credentials}
    end
  end
end
