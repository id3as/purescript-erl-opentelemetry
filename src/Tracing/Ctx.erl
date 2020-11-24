-module(openTelemetry_tracing_ctx).

-export([ new/0
        , setValue/2
        , 'setValue\''/3
        , getValue/1
        , getValueWithDefault/2
        , clear/0
        , remove/1
        , getCurrent/0
        , attach/1
        , detach/1
        ]).


new() ->
  otel_ctx:new().

setValue(Name, Value) ->
  fun() ->
      otel_ctx:set_value(Name, Value)
  end.

'setValue\''(Ctx, Name, Value) ->
  otel_ctx:set_value(Ctx, Name, Value).

getValue(Name) ->
  fun() ->
    case otel_ctx:get_value(Name) of
      undefined -> {nothing};
      V -> {just, V}
    end
  end.

getValueWithDefault(Name, Default) ->
  fun() ->
    otel_ctx:get_value(Name, Default)
  end.

clear() ->
  fun() ->
    otel_ctx:clear()
  end.

remove(Name) ->
  fun() ->
      otel_ctx:remove(Name)
  end.

getCurrent() ->
  fun() ->
      otel_ctx:get_current()
  end.

attach(Ctx) ->
  fun() ->
      otel_ctx:attach(Ctx)
  end.

detach(Token) ->
  fun() ->
      otel_ctx:detach(Token)
  end.
