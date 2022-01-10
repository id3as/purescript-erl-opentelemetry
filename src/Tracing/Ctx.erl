-module(openTelemetry_tracing_ctx@foreign).

-export([ new/0
        , setValue/2
        , setValueInCtx/3
        , getValue/1
        , getValueWithDefault/2
        , getValueInCtx/3
        , clear/0
        , clearCtx/1
        , remove/1
        , removeInCtx/2
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

setValueInCtx(Ctx, Name, Value) ->
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

getValueInCtx(Ctx, Name, Default) ->
  otel_ctx:get_value(Ctx, Name, Default).

clear() ->
  fun() ->
    otel_ctx:clear()
  end.

clearCtx(Ctx) -> otel_ctx:clear(Ctx).

remove(Name) ->
  fun() ->
      otel_ctx:remove(Name)
  end.

removeInCtx(Ctx, Name) ->
  otel_ctx:remove(Ctx, Name).

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
