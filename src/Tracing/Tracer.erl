-module(openTelemetry_tracing_tracer@foreign).

-export([ startSpan/2
        , startChildSpan/3
        , startLinkedSpan/3
        , endSpan/0
        , withSpan/3
        , setCurrentSpan/1
        , setCurrentChildSpan/2
        , currentSpan/0
        , currentChildSpan/1
        , setStatus/1
        , updateName/1
        ]).


startSpan(Tracer, SpanName) ->
  fun() ->
      otel_tracer:start_span(Tracer, SpanName, #{})
  end.

startChildSpan(Ctx, Tracer, SpanName) ->
  fun() ->
      otel_tracer:start_span(Ctx, Tracer, SpanName, #{})
  end.

startLinkedSpan(Tracer, SpanName, Links) ->
  fun() ->
    otel_tracer:start_span(Tracer, SpanName, #{links => Links})
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

setStatus(Status) ->
  fun() ->
      otel_tracer:set_status(Status)
  end.

updateName(Name) ->
  fun() ->
      otel_tracer:update_name(Name)
  end.
