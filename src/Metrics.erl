-module(openTelemetry_metrics@foreign).

%% -include_lib("opentelemetry_api/include/opentelemetry.hrl").

-export([ setDefaultMeter/1
        , getDefaultMeter/0
        , getMeter/0
        , 'getMeter\''/1
        ]).

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
