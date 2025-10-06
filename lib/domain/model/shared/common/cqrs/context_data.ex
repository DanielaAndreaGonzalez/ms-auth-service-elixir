defmodule AuthApi.Domain.Model.Shared.Common.Cqrs.ContextData do
  @moduledoc """
  ContextData structure for carrying metadata across layers.
  Immutable struct that holds tracing information.
  """

  @enforce_keys [:message_id, :x_request_id]
  defstruct [:message_id, :x_request_id]

  @type t :: %__MODULE__{
    message_id: String.t(),
    x_request_id: String.t()
  }

  @spec new(String.t(), String.t()) :: t()
  def new(message_id, x_request_id) do
    %__MODULE__{
      message_id: message_id,
      x_request_id: x_request_id
    }
  end

  @spec generate_uuid() :: String.t()
  def generate_uuid do
    UUID.uuid4()
  end
end
