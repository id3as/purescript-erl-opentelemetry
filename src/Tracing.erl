-module(openTelemetry_tracing@foreign).

-include_lib("opentelemetry_api/include/opentelemetry.hrl").

-export([ setDefaultTracer/1
        , getTracer/0
        , getNamedTracer/1
        , getVersionedTracer/3
        , getApplicationTracer/1
        , status/2
        , link/2
        , timestamp/0
        , timestampToNano/1
        , showSpanCtx/1
        ]).

setDefaultTracer(Tracer) ->
  fun() ->
    opentelemetry:set_default_tracer(Tracer)
  end.

getTracer() ->
  fun() ->
      opentelemetry:get_tracer()
  end.

getNamedTracer(TracerName) ->
  fun() ->
    opentelemetry:get_tracer(binary_to_atom(TracerName, utf8))
  end.

getVersionedTracer(TracerName, Vsn, SchemaUrl) ->
  fun() ->
    opentelemetry:get_tracer(binary_to_atom(TracerName, utf8), Vsn, SchemaUrl)
  end.

getApplicationTracer(ModuleName) ->
  fun () ->
    opentelemetry:get_application_tracer(ModuleName)
  end.

status(Code, Message) ->
  #status {
     code = binary_to_atom(Code, utf8),
     message = Message
    }.

timestamp() -> fun() ->
  opentelemetry:timestamp()
end.

timestampToNano(Timestamp) -> opentelemetry:timestamp_to_nano(Timestamp).

link(SpanCtx, Attributes) -> opentelemetry:link(SpanCtx, Attributes).

showSpanCtx(#span_ctx{ trace_id = TraceId, span_id = SpanId, trace_flags = TraceFlags, tracestate = TraceState, is_valid = IsValid, is_remote = IsRemote, is_recording = IsRecording }) ->
  Str = io_lib:format("SpanCtx {trace_id=~b, span_id=~b, trace_flags=~p, tracestate=~p, is_valid=~p, is_remote=~p, is_recording=~p}", 
    [TraceId, SpanId, TraceFlags, TraceState, IsValid, IsRemote, IsRecording]),
  unicode:characters_to_binary(Str, utf8).
  