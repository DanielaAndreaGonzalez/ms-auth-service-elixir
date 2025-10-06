defmodule AuthApi.Domain.Model.Session.Model.Session do
  @moduledoc """
  Session entity (Aggregate Root).
  """

  @enforce_keys [:id, :user_id, :session_id]
  defstruct [:id, :user_id, :session_id]

  @type t :: %__MODULE__{
    id: String.t(),
    user_id: String.t(),
    session_id: String.t()
  }

  @spec new(String.t(), String.t(), String.t()) :: t()
  def new(id, user_id, session_id) do
    %__MODULE__{
      id: id,
      user_id: user_id,
      session_id: session_id
    }
  end

  @spec create(String.t()) :: t()
  def create(user_id) do
    id = UUID.uuid4()
    session_id = UUID.uuid4()
    new(id, user_id, session_id)
  end
end
