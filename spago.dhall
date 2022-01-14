{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "erl-opentelemetry"
, dependencies =
  [ "effect"
  , "erl-atom"
  , "erl-lists"
  , "erl-maps"
  , "erl-tuples"
  , "erl-untagged-union"
  , "maybe"
  , "prelude"
  , "tuples"
  , "unsafe-reference"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, backend = "purerl"
}
