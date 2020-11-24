-module(openTelemetry_metrics_valueRecorder).

-export([int/1, float/1]).

int(Name) ->
  otel_value_recorder:definition(Name, #{
                            number_kind => integer
                           }).

float(Name) ->
  otel_value_recorder:definition(Name, #{
                            number_kind => float
                           }).
