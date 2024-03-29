module OpenTelemetry.Tracing.Ctx where

import Prelude
import OpenTelemetry (Ctx)
import Data.Maybe (Maybe)
import Effect (Effect)

foreign import data Token :: Type


foreign import new :: Ctx

foreign import setValue :: forall a. String -> a -> Effect Unit
foreign import setValueInCtx :: forall a. Ctx -> String -> a -> Ctx

foreign import getValue :: forall a. String -> Effect (Maybe a)
foreign import getValueWithDefault :: forall a. String -> a -> Effect a
foreign import getValueInCtx :: forall a. Ctx -> String -> a -> a

foreign import clear :: Effect Unit

foreign import clearCtx :: Ctx -> Ctx

foreign import remove :: String -> Effect Unit

foreign import removeInCtx :: Ctx -> String -> Ctx

foreign import getCurrent :: Effect Ctx

foreign import attach :: Ctx -> Effect Token
foreign import detach :: Token -> Effect Unit



