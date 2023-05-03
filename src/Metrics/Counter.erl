-module(openTelemetry_metrics_counter@foreign).

-export([int/1, float/1]).

int(Name) ->
  fun(Meter) ->
      otel_meter:create_counter(Meter, Name, #{description => <<>>,
                                               unit => undefined})
  end.

float(Name) ->
  fun(Meter) ->
      otel_meter:create_counter(Meter, Name, #{description => <<>>,
                                               unit => undefined})
  end.
