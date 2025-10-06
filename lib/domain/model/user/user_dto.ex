defmodule AuthApi.Domain.Model.User.UserDto do
  @moduledoc """
  User DTO for traveling through use cases.
  Immutable container for user-related data.
  """

  @enforce_keys [:email, :password]
  defstruct [:email, :password, :context]

  @type t :: %__MODULE__{
    email: String.t(),
    password: String.t(),
    context: AuthApi.Domain.Model.Shared.Common.Cqrs.ContextData.t()
  }

  @spec new(String.t(), String.t(), AuthApi.Domain.Model.Shared.Common.Cqrs.ContextData.t()) :: t()
  def new(email, password, context) do
    %__MODULE__{
      email: email,
      password: password,
      context: context
    }
  end
end
