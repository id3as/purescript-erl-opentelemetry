-module(openTelemetry_metrics_counter@foreign).

-export([int/1, float/1]).

int(Name) ->
  otel_counter:definition(Name, #{
                            number_kind => integer
                           }).

float(Name) ->
  otel_counter:definition(Name, #{
                            number_kind => float
                           }).
