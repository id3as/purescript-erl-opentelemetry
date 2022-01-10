module OpenTelemetry.Tracing.Baggage where

import Prelude

import Data.Maybe (Maybe)
import Effect (Effect)
import Erl.Data.List (List)
import Erl.Data.Tuple (Tuple2)
import OpenTelemetry (Ctx)

foreign import data Baggage :: Type

foreign import create :: List (Tuple2 String String) -> Baggage
foreign import read :: Baggage -> String -> Maybe String
foreign import write :: Baggage -> String -> String -> Baggage
foreign import toList :: Baggage -> List (Tuple2 String String)

foreign import set :: Baggage -> Effect Unit
foreign import setValue :: String -> String -> Effect Unit

foreign import setInCtx :: Ctx -> Baggage -> Ctx
foreign import setValueInCtx :: Ctx -> String -> String -> Ctx

foreign import getAll :: Effect Baggage

foreign import getAllInCtx :: Ctx -> Baggage




