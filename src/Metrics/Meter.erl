-module(openTelemetry_metrics_meter@foreign).

-export([ lookupInstrument/2
        , record/4
        ]).

-include_lib("opentelemetry_api_experimental/include/otel_metrics.hrl").

lookupInstrument(Meter, Name) ->
  fun() ->
      case otel_meter:lookupInstrument(Meter, Name) of
        undefined ->
          {nothing};
        Instrument ->
          {just, Instrument}
      end
  end.

record(Meter, #instrument{name = Name}, Attributes, Value) ->
  fun() ->
    otel_meter:record(Meter, Name, Value, Attributes)
  end.
