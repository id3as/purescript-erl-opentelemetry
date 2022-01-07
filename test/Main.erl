-module(test_main@foreign).

-export([startup/0]).

startup() -> fun () -> 
  application:ensure_all_started(opentelemetry_api),
  application:ensure_all_started(opentelemetry)
end.
