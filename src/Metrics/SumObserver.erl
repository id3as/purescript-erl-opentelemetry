-module(openTelemetry_metrics_sumObserver).

-export([int/1,
         float/1]).

int(Name) ->
  otel_sum_observer:definition(Name, #{
                                   number_kind => integer
                                  }).

float(Name) ->
  otel_sum_observer:definition(Name, #{
                                   number_kind => float
                                  }).
