-module(openTelemetry_metrics_meter@foreign).

-export([newInstrument/2
       , newInstruments/2
       , bind/2
       , record/2
       , 'record\''/3
       , add/2
       , 'add\''/3
       , registerObserver/2
       , observe/3
        ]).

-include_lib("opentelemetry_api_experimental/include/otel_metrics.hrl").

%% These lie about the return value
%% of the underlying API, but it is expected (hoped) at some point
%% that otel_meter will return something we can use
newInstrument(Meter, Definition) ->
  fun() ->
    Instance = Definition(Meter),
    { Meter, Instance }
  end.

newInstruments(Meter, Definitions) ->
  fun() ->
    lists:map(fun(Definition) ->
                  Instance = Definition(Meter),
                  { Meter, Instance }
             end, Definitions)
  end.

%% -type instrument_definition() :: {name(), instrument_kind(), instrument_opts()}.
bind({Meter, #instrument{name = Name}}, Labels) ->
  fun() ->
      {Meter, Name, Labels}
  end.

record({Meter, Name, Labels}, Value) ->
  fun() ->
    otel_meter:record(Meter, Name, Value, Labels)
  end.


'record\''({Meter, {Name, _, _ }}, Value, Labels) ->
  fun() ->
    otel_meter:record(Meter, Name, Value, Labels)
  end.

add(BoundInstrument, Value) ->
  fun() ->
    otel_meter:record(BoundInstrument, Value)
  end.

'add\''({Meter, {Name, _, _ }}, Value, Labels) ->
  fun() ->
    otel_meter:record(Meter, Name, Value, Labels)
  end.

registerObserver({Meter, Instrument = #instrument{name = Name}}, Callback) ->
  fun () ->
      otel_meter:register_callback(Meter, [Instrument], Callback, Name)
  end;

registerObserver({Meter, { Name, _, _ }}, Callback) ->
  fun () ->
      otel_meter:register_observer(Meter, Name, Callback)
  end.

observe(Name, Datum, Labels) ->
  fun () ->
      {Name, Datum, Labels}
  end.
