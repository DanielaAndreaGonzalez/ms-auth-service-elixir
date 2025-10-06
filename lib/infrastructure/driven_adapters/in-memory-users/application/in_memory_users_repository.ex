defmodule AuthApi.Infrastructure.DrivenAdapters.InMemoryUsers.InMemoryUsersRepository do
  @moduledoc """
  In-memory implementation of UsersRepository and UsersWriter.
  """

  @behaviour AuthApi.Domain.Model.User.Gateway.UsersRepository
  @behaviour AuthApi.Domain.Model.User.Gateway.UsersWriter

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def find_by_email(email) do
    GenServer.call(__MODULE__, {:find_by_email, email})
  end

  @impl true
  def save(user) do
    GenServer.call(__MODULE__, {:save, user})
  end

  @impl true
  def handle_call({:find_by_email, email}, _from, state) do
    case Map.values(state) |> Enum.find(fn user -> AuthApi.Domain.Model.Shared.Common.Validate.Email.value(user.email) == email end) do
      nil -> {:reply, {:error, :user_not_found}, state}
      user -> {:reply, {:ok, user}, state}
    end
  end

  @impl true
  def handle_call({:save, user}, _from, state) do
    email = AuthApi.Domain.Model.Shared.Common.Validate.Email.value(user.email)
    case Map.values(state) |> Enum.any?(fn u -> AuthApi.Domain.Model.Shared.Common.Validate.Email.value(u.email) == email end) do
      true -> {:reply, {:error, :email_already_exists}, state}
      false -> {:reply, :ok, Map.put(state, user.id, user)}
    end
  end
end
