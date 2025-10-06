defmodule AuthApi.Domain.UseCases.User.FindUserByEmailUseCase do
  @moduledoc """
  Find user by email use case.
  """

  alias AuthApi.Domain.Model.User.Gateway.UsersRepository

  @spec execute(String.t(), UsersRepository.t()) :: {:ok, AuthApi.Domain.Model.User.Model.User.t()} | {:error, atom()}
  def execute(email, users_repository) do
    users_repository.find_by_email(email)
  end
end
