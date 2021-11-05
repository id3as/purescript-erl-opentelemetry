-module(openTelemetry_tracing_tracer@foreign).

-export([ startSpan/2
        , startChildSpan/3
        , endSpan/0
        , withSpan/3
        , setCurrentSpan/1
        , setCurrentChildSpan/2
        , currentSpan/0
        , currentChildSpan/1
        , setAttribute/2
        , setAttributes/1
        , addEvent/2
        , setStatus/1
        , updateName/1
        ]).



%% TODO: Options
startSpan(Tracer, SpanName) ->
  fun() ->
      otel_tracer:start_span(Tracer, SpanName, #{})
  end.

startChildSpan(Ctx, Tracer, SpanName) ->
  fun() ->
      otel_tracer:start_span(Ctx, Tracer, SpanName, #{})
  end.

endSpan() ->
  fun() ->
    otel_tracer:end_span()
  end.

withSpan(Tracer, SpanName, Fun) ->
  fun() ->
    otel_tracer:with_span(Tracer, SpanName, Fun)
  end.


setCurrentSpan(SpanCtx) ->
  fun() ->
      case SpanCtx of
        {just, Span} ->
          otel_tracer:set_current_span(Span);
        {nothing} ->
          otel_tracer:set_current_span(undefined)
      end
  end.

setCurrentChildSpan(Ctx, SpanCtx) ->
  fun() ->
      case SpanCtx of
        {just, Span} ->
          otel_tracer:set_current_span(Ctx, Span);
        {nothing} ->
          otel_tracer:set_current_span(Ctx, undefined)
      end
  end.

currentSpan() ->
  fun() ->
      case otel_tracer:current_span_ctx() of
        undefined -> {nothing};
        Other -> {just, Other}
      end
  end.

currentChildSpan(Ctx) ->
  fun() ->
      case otel_tracer:current_span_ctx(Ctx) of
        undefined -> {nothing};
        Other -> {just, Other}
      end
  end.

setAttribute(Name, Value) ->
  fun() ->
      otel_tracer:set_attribute(Name, Value)
  end.

setAttributes(Attributes) ->
  fun() ->
      otel_tracer:set_attributes(openTelemetry_tracing_span@foreign:record_to_list(Attributes))
  end.

addEvent(Event, Attributes) ->
  fun() ->
      otel_tracer:add_event(Event, openTelemetry_tracing_span@foreign:record_to_list(Attributes))
  end.

setStatus(Status) ->
  fun() ->
      otel_tracer:set_status(Status)
  end.

updateName(Name) ->
  fun() ->
      otel_tracer:update_name(Name)
  end.
