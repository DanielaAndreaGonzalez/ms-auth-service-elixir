defmodule AuthApi.Infrastructure.EntryPoints.ReactiveWeb.Application.SigninHandler do
  @moduledoc """
  Handler for signin endpoint.
  """

  alias AuthApi.Domain.UseCases.Session.SigninUseCase
  alias AuthApi.Domain.Model.Session.SessionDto
  alias AuthApi.Domain.Model.Shared.Common.Cqrs.ContextData
  alias AuthApi.Infrastructure.DrivenAdapters.InMemoryUsers.InMemoryUsersRepository
  alias AuthApi.Infrastructure.DrivenAdapters.Sessions.Memory.InMemorySessionsRepository

  def signin(conn, %{"email" => email, "password" => password}) do
    context = build_context(conn)

    dto = SessionDto.new(email, password, context)

    case SigninUseCase.execute(dto, InMemoryUsersRepository, InMemorySessionsRepository) do
      {:ok, session_id} ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(200, Poison.encode!(%{session_id: session_id}))
      {:error, reason} ->
        handle_error(conn, reason)
    end
  end

  def signin(conn, _params) do
    handle_error(conn, :malformed_request)
  end

  defp build_context(conn) do
    message_id = Plug.Conn.get_req_header(conn, "message-id") |> List.first() || ContextData.generate_uuid()
    x_request_id = Plug.Conn.get_req_header(conn, "x-request-id") |> List.first() || message_id
    ContextData.new(message_id, x_request_id)
  end

  defp handle_error(conn, :user_not_found) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(404, Poison.encode!(%{code: "USER_NOT_FOUND", detail: "User not found", category: "BEX_ECS"}))
  end

  defp handle_error(conn, :invalid_credentials) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(401, Poison.encode!(%{code: "INVALID_CREDENTIALS", detail: "Invalid credentials", category: "BEX_ECS"}))
  end

  defp handle_error(conn, :malformed_request) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(400, Poison.encode!(%{code: "MALFORMED_REQUEST", detail: "Malformed request", category: "BEX_ECS"}))
  end
end
