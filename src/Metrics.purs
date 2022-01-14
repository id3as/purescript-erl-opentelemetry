module OpenTelemetry.Metrics
  ( Additive
  , Additivity(..)
  , Asynchronous
  , BoundInstrument
  , Instrument
  , InstrumentDefinition
  , InstrumentName(..)
  , Label
  , Meter
  , MeterName(..)
  , MeterVersion(..)
  , Monotonic
  , Monotonicity(..)
  , NonAdditive
  , NonMonotonic
  , ObserverResult
  , Synchronicity(..)
  , Synchronous
  , getDefaultMeter
  , getMeter
  , getMeter'
  , label
  , registerApplicationMeter
  , registerMeter
  , setDefaultMeter
  )
  where

import Prelude

import Effect (Effect)
import Erl.Data.Tuple (Tuple2, tuple2)

foreign import data Meter :: Type
data Synchronicity
foreign import data Synchronous :: Synchronicity
foreign import data Asynchronous :: Synchronicity

data Additivity
foreign import data Additive :: Additivity
foreign import data NonAdditive :: Additivity

data Monotonicity
foreign import data Monotonic :: Monotonicity
foreign import data NonMonotonic :: Monotonicity

type Label = Tuple2 String String

label :: String -> String -> Label
label = tuple2

newtype InstrumentName = InstrumentName String
derive instance eqInstrumentName :: Eq InstrumentName
instance showInstrumentName :: Show InstrumentName where
  show (InstrumentName n) = "InstrumentName " <> n

newtype MeterName = MeterName String
instance showMeterName :: Show MeterName where
  show (MeterName n) = "MeterName " <> n

newtype MeterVersion = MeterVersion String
instance showMeterVersion :: Show MeterVersion where
  show (MeterVersion n) = "MeterVersion " <> n

data InstrumentDefinition :: Synchronicity -> Additivity -> Monotonicity -> Type -> Type
data InstrumentDefinition s a m d = InstrumentDefinition InstrumentName

data Instrument :: Synchronicity -> Additivity -> Monotonicity -> Type -> Type
data Instrument s a m d = Instrument (InstrumentDefinition s a m d)

data BoundInstrument :: Synchronicity -> Additivity -> Monotonicity -> Type -> Type
data BoundInstrument s a m d = BoundInstrument (InstrumentDefinition s a m d)

data ObserverResult :: Additivity -> Monotonicity -> Type -> Type
data ObserverResult a m d = ObserverResult

foreign import registerMeter :: MeterName -> MeterVersion -> Effect Unit
foreign import registerApplicationMeter :: MeterName -> Effect Unit
foreign import setDefaultMeter :: Meter -> Effect Unit
foreign import getDefaultMeter :: Effect Meter
foreign import getMeter :: Effect Meter
foreign import getMeter' :: MeterName -> Effect Meter
