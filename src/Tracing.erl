-module(openTelemetry_tracing@foreign).

-include_lib("opentelemetry_api/include/opentelemetry.hrl").

-export([ setDefaultTracer/1
        , getDefaultTracer/0
        , getTracer/0
        , 'getTracer\''/1
        , getTracerVersioned/3
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

getDefaultTracer() ->
  fun() ->
      opentelemetry:get_tracer()
  end.

% -spec get_tracer(Name, Vsn, SchemaUrl) -> Tracer when
%       Name :: atom(),
%       Vsn :: unicode:chardata() | undefined,
%       SchemaUrl :: uri_string:uri_string() | undefined,
%       Tracer:: opentelemetry:tracer().


getTracer() ->
  [{current_stacktrace, Stack}] = erlang:process_info(self(), [current_stacktrace]),
  fun() ->
    {Module, _Fun, _Arity, _File, _Line} = walk_stack(Stack),
    opentelemetry:get_tracer(Module)
  end.

'getTracer\''(TracerName) ->
  fun() ->
    opentelemetry:get_tracer(binary_to_atom(TracerName, utf8))
  end.

getTracerVersioned(TracerName, Vsn, SchemaUrl) ->
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

walk_stack([_LoggerFrame | Stack = [{TopModule, TopFun, TopArity, [{file, TopFile}, {line, TopLine}]} | _]]) ->
  walk_stack_internal({TopModule, TopFun, TopArity, TopFile, TopLine}, Stack).

walk_stack_internal(Default, [{Module, Fun, Arity, [{file, File}, {line, Line}]} | Rest]) ->
  ModuleStr = atom_to_list(Module),
  case string:prefix(ModuleStr, "openTelemetry") of
    nomatch ->
      case string:find(ModuleStr, "@ps") of
        "@ps" ->
          {format(ModuleStr), Fun, Arity, File, Line};
        _ ->
          walk_stack_internal(Default, Rest)
      end;
    _ ->
      walk_stack_internal(Default, Rest)
  end;

walk_stack_internal(Default, []) -> Default.

format(Str) ->
  list_to_atom(string:join([camel(Token) || Token <- string:tokens(Str, "_")], ".")).

camel([H | T]) when $a =< H, H =< $z ->
  [H - 32 | T];
camel(Other) ->
  Other.

link(SpanCtx, Attributes) -> opentelemetry:link(SpanCtx, Attributes).

showSpanCtx(#span_ctx{ trace_id = TraceId, span_id = SpanId, trace_flags = TraceFlags, tracestate = TraceState, is_valid = IsValid, is_remote = IsRemote, is_recording = IsRecording }) ->
  Str = io_lib:format("SpanCtx {trace_id=~b, span_id=~b, trace_flags=~p, tracestate=~p, is_valid=~p, is_remote=~p, is_recording=~p}", 
    [TraceId, SpanId, TraceFlags, TraceState, IsValid, IsRemote, IsRecording]),
  unicode:characters_to_binary(Str, utf8).
  