module OpenTelemetry.Tracing.Propagator.TextMap where


import Effect (Effect)
import Erl.Data.List (List, nil)
import Erl.Data.Tuple (Tuple2)
import OpenTelemetry (Ctx)

foreign import data Propagator :: Type

-- | Text map propagator default carrier (a list of tuples of ASCII-ish binary strings)
newtype DefaultCarrier = DefaultCarrier (List (Tuple2 String String))

defaultCarrier :: DefaultCarrier
defaultCarrier = DefaultCarrier nil

foreign import inject :: DefaultCarrier -> Effect DefaultCarrier

foreign import extract :: DefaultCarrier -> Effect Ctx
