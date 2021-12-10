-module(openTelemetry@foreign).

-include_lib("opentelemetry_api/include/opentelemetry.hrl").

-export([ registerMeter/2
        , registerApplicationMeter/1
        , setDefaultMeter/1
        , getDefaultMeter/0
        , getMeter/0
        , 'getMeter\''/1
        , registerTracer/2
        , registerApplicationTracer/1
        , setDefaultTracer/1
        , getDefaultTracer/0
        , getTracer/0
        , 'getTracer\''/1
        , status/2
        , link/2
        ]).

registerMeter(Name, Version) ->
  fun() ->
    opentelemetry_experimental:register_meter(binary_to_atom(Name, utf8), Version)
  end.

registerApplicationMeter(Name) ->
  fun() ->
    opentelemetry_experimental:register_application_meter(binary_to_atom(Name, utf8))
  end.

setDefaultMeter(Meter) ->
  fun() ->
    opentelemetry_experimental:set_default_meter(Meter)
  end.

getDefaultMeter() ->
  fun() ->
      opentelemetry_experimental:get_meter()
  end.

getMeter() ->
  [{current_stacktrace, Stack}] = erlang:process_info(self(), [current_stacktrace]),
  fun() ->
    {Module, _Fun, _Arity, _File, _Line} = walk_stack(Stack),
    opentelemetry_experimental:get_meter(Module)
  end.

'getMeter\''(MeterName) ->
  fun() ->
    opentelemetry_experimental:get_meter(binary_to_atom(MeterName, utf8))
  end.

registerTracer(Name, Version) ->
  fun() ->
    opentelemetry:register_tracer(binary_to_atom(Name, utf8), Version)
  end.

registerApplicationTracer(Name) ->
  fun() ->
    opentelemetry:register_application_tracer(binary_to_atom(Name, utf8))
  end.

setDefaultTracer(Tracer) ->
  fun() ->
    opentelemetry:set_default_tracer(Tracer)
  end.

getDefaultTracer() ->
  fun() ->
      opentelemetry:get_tracer()
  end.

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

status(Code, Message) ->
  #status {
     code = binary_to_atom(Code, utf8),
     message = Message
    }.

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