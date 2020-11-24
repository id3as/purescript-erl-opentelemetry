module OpenTelemetry.Tracing.Baggage where

import Prelude
import Effect (Effect)
import Erl.Data.Tuple (Tuple2)
import Erl.Data.List (List)

foreign import data Baggage :: Type

foreign import create :: List (Tuple2 String String) -> Baggage
foreign import read :: Baggage -> String -> String
foreign import write :: Baggage -> String -> String -> Baggage
foreign import toList :: Baggage -> List (Tuple2 String String)

foreign import set :: Baggage -> Effect Unit
foreign import get :: Effect Baggage




