defmodule AuthApi.Domain.Model.Shared.Common.Cqrs.Command do
  @moduledoc """
  Command structure for CQRS pattern.
  Commands represent write operations that change the state of the system.
  They do not return values.
  """

  @enforce_keys [:payload, :context]
  defstruct [:payload, :context]

  @type t :: %__MODULE__{
    payload: map(),
    context: AuthApi.Domain.Model.Shared.Common.Cqrs.ContextData.t()
  }

  @spec new(map(), AuthApi.Domain.Model.Shared.Common.Cqrs.ContextData.t()) :: t()
  def new(payload, context) do
    %__MODULE__{
      payload: payload,
      context: context
    }
  end
end
