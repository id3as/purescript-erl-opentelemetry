-module(openTelemetry_tracing_span@foreign).

-export([ traceId/1
        , hexTraceId/1
        , spanId/1
        , hexSpanId/1
        , traceState/1
        , isRecording/1
        , setAttribute/3
        , setAttributes/2
        , addEvent/3
        , setStatus/2
        , updateName/2
        , endSpan/1
        ]).

record_to_list(Record) ->
  lists:map(fun({Key, Value}) ->
                { atom_to_binary(Key, utf8), Value }
            end, maps:to_list(Record)).

traceId(SpanCtx) ->
  otel_span:trace_id(SpanCtx).


hexTraceId(SpanCtx) ->
  otel_span:hex_trace_id(SpanCtx).

spanId(SpanCtx) ->
  otel_span:span_id(SpanCtx).

hexSpanId(SpanCtx) ->
  otel_span:hex_span_id(SpanCtx).

traceState(SpanCtx) ->
  otel_span:trace_state(SpanCtx).

isRecording(SpanCtx) ->
  otel_span:is_recording(SpanCtx).

setAttribute(SpanCtx, Name, Value) ->
  fun() ->
    otel_span:set_attribute(SpanCtx, Name, Value)
  end.

setAttributes(SpanCtx, Attributes) ->
  fun() ->
    otel_span:set_attributes(SpanCtx, record_to_list(Attributes))
  end.

addEvent(SpanCtx, Event, Attributes) ->
  fun() ->
    otel_span:add_event(SpanCtx, Event, record_to_list(Attributes))
  end.

setStatus(SpanCtx, Status) ->
  fun() ->
    otel_span:set_status(SpanCtx, Status)
  end.

updateName(SpanCtx, Name) ->
  fun() ->
    otel_span:update_name(SpanCtx, Name)
  end.

endSpan(SpanCtx) ->
  fun() ->
    otel_span:end_span(SpanCtx)
  end.
