-module(openTelemetry_metrics_counter@foreign).

-export([create/3]).

create(Meter, Name, Opts) ->
  fun() ->
      otel_meter:create_counter(Meter, Name, Opts)
  end.
