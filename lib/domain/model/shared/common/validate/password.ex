defmodule AuthApi.Domain.Model.Shared.Common.Validate.Password do
  @moduledoc """
  Value object for Password with validation.
  """

  @enforce_keys [:value]
  defstruct [:value]

  @type t :: %__MODULE__{
    value: String.t()
  }

  @min_length 8

  @spec new(String.t()) :: {:ok, t()} | {:error, String.t()}
  def new(value) when is_binary(value) do
    if String.length(value) >= @min_length do
      {:ok, %__MODULE__{value: value}}
    else
      {:error, :weak_password}
    end
  end

  def new(_), do: {:error, :weak_password}

  @spec value(t()) :: String.t()
  def value(%__MODULE__{value: value}), do: value
end
