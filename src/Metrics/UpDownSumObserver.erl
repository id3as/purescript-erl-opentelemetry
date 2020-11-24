-module(openTelemetry_metrics_upDownSumObserver@foreign).

-export([int/1,
         float/1]).

int(Name) ->
  otel_updown_sum_observer:definition(Name, #{
                                   number_kind => integer
                                  }).

float(Name) ->
  otel_updown_sum_observer:definition(Name, #{
                                   number_kind => float
                                  }).
