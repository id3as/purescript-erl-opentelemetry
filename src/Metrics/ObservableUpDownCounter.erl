-module(openTelemetry_metrics_observableUpDownCounter@foreign).

-export([create/4]).

create(Meter, Name, Callback, Opts) ->
  fun() ->
      otel_meter:create_observable_updowncounter(Meter, Name, fun(Arg) ->
                                                                     case Callback(Arg) of
                                                                         {observation, O} ->
                                                                             O;
                                                                         {namedObservation, Val} ->
                                                                             Val
                                                                     end
                                                             end, Name, Opts)
  end.
