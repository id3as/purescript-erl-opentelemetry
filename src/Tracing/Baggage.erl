-module(openTelemetry_tracing_baggage).

-export([ create/1
        , read/2
        , write/3
        , toList/1
        , set/1
        , get/0
        ]).


create(Values) ->
  maps:from_list(Values).

read(Baggage, Key) ->
  maps:get(Baggage, Key, "").

write(Baggage, Key, Value) ->
  maps:update(Key, Value, Baggage).

toList(Baggage) ->
  maps:to_list(Baggage).

set(Baggage) ->
  fun() ->
    otel_baggage:set(Baggage)
  end.

get() ->
  fun() ->
    otel_baggage:get_all()
  end.
