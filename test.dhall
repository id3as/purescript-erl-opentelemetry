let base = ./spago.dhall

in    base
    ⫽ { sources =
          base.sources # [ "test/**/*.purs" ]
      , dependencies =
          base.dependencies # [
          , "erl-test-eunit"
          , "free"
          , "assert"
          ]
      }
