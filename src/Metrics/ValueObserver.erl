-module(openTelemetry_metrics_valueObserver@foreign).

-export([int/3,
         float/3]).

int(Name, Description, Unit) ->
  fun(Meter) ->
      otel_meter:create_counter(Meter, Name, #{description => Description,
                                               unit => Unit})
  end.

float(Name, Description, Unit) ->
  fun(Meter) ->
      otel_meter:create_counter(Meter, Name, #{description => Description,
                                               unit => Unit})
  end.
