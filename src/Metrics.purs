module OpenTelemetry.Metrics
  ( Additive
  , Additivity(..)
  , Asynchronous
  , Instrument
  , InstrumentAttributes(..)
  , InstrumentCallback
  , InstrumentCallbackResult(..)
  , InstrumentObservation
  , InstrumentNamedObservation
  , InstrumentName(..)
  , InstrumentOptions
  , InstrumentUnit(..)
  , InstrumentDescription(..)
  , Meter
  , MeterName(..)
  , MeterVersion(..)
  , Monotonic
  , Monotonicity(..)
  , NonAdditive
  , NonMonotonic
  , Synchronicity(..)
  , Synchronous
  , getDefaultMeter
  , getMeter
  , getMeter'
  , setDefaultMeter
  , mergeInstrumentAttributes
  , emptyInstrumentAttributes
  ) where

import Prelude

import Data.Newtype (class Newtype)
import Effect.Uncurried (EffectFn1)
import Effect (Effect)
import Erl.Atom (Atom)
import Erl.Data.List (List)
import Erl.Data.Map (Map)
import Erl.Data.Map as Map
import Erl.Data.Tuple (Tuple2)

data Synchronicity

foreign import data Synchronous :: Synchronicity
foreign import data Asynchronous :: Synchronicity

data Additivity

foreign import data Additive :: Additivity
foreign import data NonAdditive :: Additivity

data Monotonicity

foreign import data Monotonic :: Monotonicity
foreign import data NonMonotonic :: Monotonicity

newtype InstrumentAttributes = InstrumentAttributes (Map Atom String)

derive instance Eq InstrumentAttributes
derive instance Ord InstrumentAttributes
derive instance Newtype InstrumentAttributes _

instance Show InstrumentAttributes where
  show (InstrumentAttributes map) = show map

mergeInstrumentAttributes :: InstrumentAttributes -> InstrumentAttributes -> InstrumentAttributes
mergeInstrumentAttributes (InstrumentAttributes lhs) (InstrumentAttributes rhs) =
  InstrumentAttributes $ Map.union lhs rhs

emptyInstrumentAttributes :: InstrumentAttributes
emptyInstrumentAttributes =
  InstrumentAttributes Map.empty

newtype InstrumentName :: Synchronicity -> Additivity -> Monotonicity -> Type -> Type
newtype InstrumentName s a m d = InstrumentName Atom

derive instance Eq (InstrumentName s a m d)
instance Show (InstrumentName s a m d) where
  show (InstrumentName n) = "InstrumentName " <> (show n)

newtype InstrumentUnit = InstrumentUnit Atom

derive instance Eq InstrumentUnit
instance Show InstrumentUnit where
  show (InstrumentUnit n) = "InstrumentUnit " <> show n

newtype InstrumentDescription = InstrumentDescription String

derive instance Eq InstrumentDescription
instance Show InstrumentDescription where
  show (InstrumentDescription n) = "InstrumentDescription " <> show n

newtype MeterName = MeterName String

instance Show MeterName where
  show (MeterName n) = "MeterName " <> n

newtype MeterVersion = MeterVersion String

instance Show MeterVersion where
  show (MeterVersion n) = "MeterVersion " <> n

foreign import data Meter :: Type

type InstrumentOptions =
  { description :: InstrumentDescription
  , unit :: InstrumentUnit
  }

type InstrumentObservation :: Type -> Type
type InstrumentObservation d = Tuple2 d InstrumentAttributes

type InstrumentNamedObservation :: Additivity -> Monotonicity -> Type -> Type
type InstrumentNamedObservation a m d = Tuple2 (InstrumentName Asynchronous a m d) (List (InstrumentObservation d))

data InstrumentCallbackResult :: Additivity -> Monotonicity -> Type -> Type
data InstrumentCallbackResult a m d
  = Observation (List (InstrumentObservation d))
  | NamedObservation (List (InstrumentNamedObservation a m d))

type InstrumentCallback :: Additivity -> Monotonicity -> Type -> Type
type InstrumentCallback a m d = EffectFn1 (InstrumentName Asynchronous a m d) (InstrumentCallbackResult a m d)

foreign import data Instrument :: Synchronicity -> Additivity -> Monotonicity -> Type -> Type

foreign import setDefaultMeter :: Meter -> Effect Unit
foreign import getDefaultMeter :: Effect Meter
foreign import getMeter :: Effect Meter
foreign import getMeter' :: MeterName -> Effect Meter
