-module(openTelemetry_tracing_tracer@foreign).

-export([ startSpanImpl/3
        , startChildSpanImpl/4
        , withSpanImpl/4
        , setCurrentSpan/1
        , setCurrentChildSpan/2
        , currentSpan/0
        , currentChildSpan/1
        ]).


startSpanImpl(Tracer, SpanName, Opts) ->
  fun() ->
    otel_tracer:start_span(Tracer, SpanName, Opts)
  end.

startChildSpanImpl(Ctx, Tracer, SpanName, Opts) ->
  fun() ->
    otel_tracer:start_span(Ctx, Tracer, SpanName, Opts)
  end.

withSpanImpl(Tracer, SpanName, Opts, Fun) ->
  fun() ->
    otel_tracer:with_span(Tracer, SpanName, Opts, Fun)
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
