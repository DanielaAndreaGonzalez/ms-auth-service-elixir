defmodule AuthApi.Infrastructure.DrivenAdapters.Sessions.Memory.InMemorySessionsRepository do
  @moduledoc """
  In-memory implementation of SessionsRepository.
  """

  @behaviour AuthApi.Domain.Model.Session.Gateway.SessionsRepository

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def save(session) do
    GenServer.call(__MODULE__, {:save, session})
  end

  @impl true
  def find_by_user_id(user_id) do
    GenServer.call(__MODULE__, {:find_by_user_id, user_id})
  end

  @impl true
  def handle_call({:save, session}, _from, state) do
    {:reply, :ok, Map.put(state, session.user_id, session)}
  end

  @impl true
  def handle_call({:find_by_user_id, user_id}, _from, state) do
    case Map.get(state, user_id) do
      nil -> {:reply, {:error, :session_not_found}, state}
      session -> {:reply, {:ok, session}, state}
    end
  end
end
