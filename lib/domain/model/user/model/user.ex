defmodule AuthApi.Domain.Model.User.Model.User do
  @moduledoc """
  User entity (Aggregate Root).
  """

  alias AuthApi.Domain.Model.Shared.Common.Validate.Email
  alias AuthApi.Domain.Model.Shared.Common.Validate.Password

  @enforce_keys [:id, :email, :password]
  defstruct [:id, :email, :password]

  @type t :: %__MODULE__{
    id: String.t(),
    email: Email.t(),
    password: Password.t()
  }

  @spec new(String.t(), Email.t(), Password.t()) :: t()
  def new(id, email, password) do
    %__MODULE__{
      id: id,
      email: email,
      password: password
    }
  end

  @spec create(Email.t(), Password.t()) :: t()
  def create(email, password) do
    id = UUID.uuid4()
    new(id, email, password)
  end
end
