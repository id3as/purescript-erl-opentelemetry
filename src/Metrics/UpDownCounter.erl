-module(openTelemetry_metrics_upDownCounter@foreign).

-export([int/1,
         float/1]).

int(Name) ->
  otel_updown_counter:definition(Name, #{
                            number_kind => integer
                           }).

float(Name) ->
  otel_updown_counter:definition(Name, #{
                            number_kind => float
                           }).
