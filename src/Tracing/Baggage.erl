-module(openTelemetry_tracing_baggage@foreign).

-export([ create/1
        , read/2
        , write/3
        , toList/1
        , set/1
        , setValue/2
        , setInCtx/2
        , setValueInCtx/3
        , getAll/0
        , getAllInCtx/1
        ]).


create(Values) ->
  maps:from_list(Values).

read(Baggage, Key) ->
  case maps:get(Key, Baggage, undefined) of
    undefined -> {nothing};
    {Value,_Metadata} -> {just, Value}
  end.

write(Baggage, Key, Value) ->
  maps:update(Key, Value, Baggage).

toList(Baggage) ->
  maps:to_list(Baggage).

set(Baggage) ->
  fun() ->
    otel_baggage:set(Baggage)
  end.

setValue(Key, Value) ->
  fun() ->
    otel_baggage:set(Key, Value)
  end.

setInCtx(Ctx, Baggage) ->
  otel_baggage:set(Ctx, Baggage).

setValueInCtx(Ctx, Key, Value) ->
  otel_baggage:set(Ctx, Key, Value).

getAll() ->
  fun() ->
    otel_baggage:get_all()
  end.

getAllInCtx(Ctx) ->
  otel_baggage:get_all(Ctx).
