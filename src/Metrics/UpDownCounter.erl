-module(openTelemetry_metrics_upDownCounter@foreign).

-export([create/3]).

create(Meter, Name, Opts) ->
  fun() ->
      otel_meter:create_updown_counter(Meter, Name, Opts)
  end.
