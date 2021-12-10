{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "erl-opentelemetry"
, dependencies =
  [ "effect", "erl-lists", "erl-tuples", "maybe", "prelude" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, backend = "purerl"
}
