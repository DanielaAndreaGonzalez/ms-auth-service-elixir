import Config

config :auth_api,
  timezone: "America/Bogota",
  env: :prod,
  http_port: 8083,
  enable_server: true,
  version: "0.0.1",
  custom_metrics_prefix_name: "auth_api"

config :logger,
  level: :warning

# tracer
config :opentelemetry,
  text_map_propagators: [:baggage, :trace_context],
  span_processor: :batch,
  traces_exporter: :otlp,
  resource_detectors: [
    :otel_resource_app_env,
    :otel_resource_env_var,
    OtelResourceDynatrace
  ]

config :opentelemetry_exporter,
  otlp_protocol: :http_protobuf,
  otlp_endpoint: "http://localhost:4318"
