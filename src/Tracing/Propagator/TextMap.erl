-module(openTelemetry_tracing_propagator_textMap@foreign).

-export([inject/1,extract/1]).

inject(Carrier) -> fun () ->
  otel_propagator_text_map:inject(Carrier)
end.

extract(Carrier) -> fun () ->
  otel_propagator_text_map:extract(Carrier)
end.