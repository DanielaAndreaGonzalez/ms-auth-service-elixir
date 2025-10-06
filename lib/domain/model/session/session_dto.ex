defmodule AuthApi.Domain.Model.Session.SessionDto do
  @moduledoc """
  Session DTO for traveling through use cases.
  Immutable container for session-related data.
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
