defmodule AuthApi.Infrastructure.EntryPoints.ReactiveWeb.Application.SignupHandler do
  @moduledoc """
  Handler for signup endpoint.
  """

  alias AuthApi.Domain.UseCases.User.SignupUseCase
  alias AuthApi.Domain.Model.User.UserDto
  alias AuthApi.Domain.Model.Shared.Common.Cqrs.ContextData
  alias AuthApi.Infrastructure.DrivenAdapters.InMemoryUsers.InMemoryUsersRepository

  def signup(conn, %{"email" => email, "password" => password}) do
    context = build_context(conn)

    dto = UserDto.new(email, password, context)

    case SignupUseCase.execute(dto, InMemoryUsersRepository, InMemoryUsersRepository) do
      :ok ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(201, Poison.encode!(%{}))
      {:error, reason} ->
        handle_error(conn, reason)
    end
  end

  def signup(conn, _params) do
    handle_error(conn, :malformed_request)
  end

  defp build_context(conn) do
    message_id = Plug.Conn.get_req_header(conn, "message-id") |> List.first() || ContextData.generate_uuid()
    x_request_id = Plug.Conn.get_req_header(conn, "x-request-id") |> List.first() || message_id
    ContextData.new(message_id, x_request_id)
  end

  defp handle_error(conn, :email_already_exists) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(409, Poison.encode!(%{code: "EMAIL_ALREADY_EXISTS", detail: "Email already exists", category: "BEX_ECS"}))
  end

  defp handle_error(conn, :invalid_email_format) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(400, Poison.encode!(%{code: "INVALID_EMAIL_FORMAT", detail: "Invalid email format", category: "BEX_ECS"}))
  end

  defp handle_error(conn, :weak_password) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(400, Poison.encode!(%{code: "WEAK_PASSWORD", detail: "Password must be at least 8 characters", category: "BEX_ECS"}))
  end

  defp handle_error(conn, :malformed_request) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(400, Poison.encode!(%{code: "MALFORMED_REQUEST", detail: "Malformed request", category: "BEX_ECS"}))
  end
end
