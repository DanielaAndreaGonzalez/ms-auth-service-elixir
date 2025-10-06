defmodule AuthApi.Domain.Model.Shared.Common.Validate.Email do
  @moduledoc """
  Value object for Email with validation.
  """

  @enforce_keys [:value]
  defstruct [:value]

  @type t :: %__MODULE__{
    value: String.t()
  }

  @email_regex ~r/^[^\s@]+@[^\s@]+\.[^\s@]+$/

  @spec new(String.t()) :: {:ok, t()} | {:error, String.t()}
  def new(value) when is_binary(value) do
    if Regex.match?(@email_regex, value) do
      {:ok, %__MODULE__{value: value}}
    else
      {:error, :invalid_email_format}
    end
  end

  def new(_), do: {:error, :invalid_email_format}

  @spec value(t()) :: String.t()
  def value(%__MODULE__{value: value}), do: value
end
