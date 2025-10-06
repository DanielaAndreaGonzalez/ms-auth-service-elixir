defmodule AuthApi.Infrastructure.EntryPoint.ApiRest do
  @compile if Mix.env() == :test, do: :export_all
  @moduledoc """
  Access point to the rest exposed services
  """
  # alias AuthApi.Utils.DataTypeUtils
  require Logger
  use Plug.Router
  use Timex

  plug(CORSPlug,
    methods: ["GET", "POST", "PUT", "DELETE"],
    # Avoid using a compiled regex here because it contains an internal
    # Erlang reference which cannot be Macro.escaped at compile time. Use
    # a simple wildcard string origin which CORSPlug accepts.
    origin: ["*"],
    headers: ["Content-Type", "Accept", "User-Agent"]
  )

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(OpentelemetryPlug.Propagation)
  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison)
  plug(Plug.Telemetry, event_prefix: [:auth_api, :plug])
  plug(:dispatch)

  forward(
    "/api/health",
    to: PlugCheckup,
    init_opts:
      PlugCheckup.Options.new(
        json_encoder: Jason,
        checks: AuthApi.Infrastructure.EntryPoint.HealthCheck.checks()
      )
  )

  get "/api/hello" do
    build_response("Hello World", conn)
  end

  post "/api/signup" do
    AuthApi.Infrastructure.EntryPoints.ReactiveWeb.Application.SignupHandler.signup(conn, conn.body_params)
  end

  post "/api/signin" do
    AuthApi.Infrastructure.EntryPoints.ReactiveWeb.Application.SigninHandler.signin(conn, conn.body_params)
  end

  def build_response(%{status: status, body: body}, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  def build_response(response, conn), do: build_response(%{status: 200, body: response}, conn)

  match _ do
    conn
    |> handle_not_found(Logger.level())
  end

  # defp build_bad_request_error_response(response, conn) do
  #   build_response(%{status: 400, body: response}, conn)
  # end

  defp handle_not_found(conn, :debug) do
    %{request_path: path} = conn
    body = Poison.encode!(%{status: 404, path: path})
    send_resp(conn, 404, body)
  end

  defp handle_not_found(conn, _level) do
    send_resp(conn, 404, "")
  end
end
