{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "erl-opentelemetry"
, dependencies = [ "console" "effect" "erl-list" "erl-tuple" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
,backend = "purerl"
}
