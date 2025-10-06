defmodule AuthApi.Domain.Model.Shared.Common.Cqrs.Query do
  @moduledoc """
  Query structure for CQRS pattern.
  Queries represent read operations that retrieve data without changing state.
  They return values.
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
