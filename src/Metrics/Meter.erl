-module(openTelemetry_metrics_meter@foreign).

-export([newInstrument/2
       , newInstruments/2
       , bind/2
       , record/2
       , 'record\''/2
       , add/2
       , 'add\''/2
       , registerObserver/2
       , observe/3
        ]).

%% These lie about the return value
%% of the underlying API, but it is expected (hoped) at some point
%% that otel_meter will return something we can use
newInstrument(Meter, Definition) ->
  fun() ->
    otel_meter:new_instruments(Meter, [Definition]),
    { Meter, Definition }
  end.

newInstruments(Meter, Definitions) ->
  fun() ->
    otel_meter:new_instruments(Meter, Definitions),
    list:map(fun(Def) ->
                 { Meter, Def }
             end, Definitions)
  end.

%% -type instrument_definition() :: {name(), instrument_kind(), instrument_opts()}.
bind({Meter, {Name, _, _}}, Labels) ->
  fun() ->
      otel_meter:bind(Meter, Name, Labels)
  end.

record(BoundInstrument, Value) ->
  fun() ->
    otel_meter:record(BoundInstrument, Value)
  end.

'record\''({Meter, {Name, _, _ }}, Value) ->
  fun() ->
    otel_meter:record(Meter, Name, Value)
  end.

add(BoundInstrument, Value) ->
  fun() ->
    otel_meter:add(BoundInstrument, Value)
  end.

'add\''({Meter, {Name, _, _ }}, Value) ->
  fun() ->
    otel_meter:add(Meter, Name, Value)
  end.

registerObserver({Meter, { Name, _, _ }}, Callback) -> fun () ->
  otel_meter:register_observer(Meter, Name, Callback)
end.

observe(ObserverResult, Datum, Labels) -> fun () ->
  otel_meter:observe(ObserverResult, Datum, Labels)
end.
