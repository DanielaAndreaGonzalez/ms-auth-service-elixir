defmodule AuthApi.Domain.UseCases.User.SignupUseCase do
  @moduledoc """
  Signup use case: handles user registration.
  """

  alias AuthApi.Domain.Model.User.UserDto
  alias AuthApi.Domain.Model.User.Model.User
  alias AuthApi.Domain.Model.Shared.Common.Validate.Email
  alias AuthApi.Domain.Model.Shared.Common.Validate.Password
  alias AuthApi.Domain.Model.User.Gateway.UsersWriter
  alias AuthApi.Domain.Model.User.Gateway.UsersRepository

  @spec execute(UserDto.t(), UsersWriter.t(), UsersRepository.t()) :: :ok | {:error, atom()}
  def execute(%UserDto{email: email_str, password: password_str}, users_writer, users_repository) do
    with {:ok, email} <- Email.new(email_str),
         {:ok, password} <- Password.new(password_str),
         {:error, :user_not_found} <- users_repository.find_by_email(email_str) do
      user = User.create(email, password)
      users_writer.save(user)
    else
      {:ok, _user} -> {:error, :email_already_exists}
      {:error, reason} -> {:error, reason}
    end
  end
end
