-module(openTelemetry_metrics_valueObserver@foreign).

-export([int/1,
         float/1]).

int(Name) ->
  otel_value_observer:definition(Name, #{
                                   number_kind => integer
                                  }).

float(Name) ->
  otel_value_observer:definition(Name, #{
                                   number_kind => float
                                  }).
