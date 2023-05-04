-module(openTelemetry_metrics_sumObserver@foreign).

-export([int/3,
         float/3]).

int(Name, Description, Unit) ->
  otel_sum_observer:definition(Name, #{
                                   number_kind => integer
                                  }).

float(Name, Description, Unit) ->
  otel_sum_observer:definition(Name, #{
                                   number_kind => float
                                  }).
