module OpenTelemetry where

import Prelude

import Effect (Effect)
import Erl.Data.List (List)
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

foreign import data Tracer :: Type

newtype TracerName = TracerName String
instance showTracerName :: Show TracerName where
  show (TracerName n) = "TracerName " <> n

newtype TracerVersion = TracerVersion String
instance showTracerVersion :: Show TracerVersion where
  show (TracerVersion n) = "TracerVersion " <> n

newtype SpanName = SpanName String
instance showSpanName :: Show SpanName where
  show (SpanName n) = "SpanName " <> n

newtype StatusCode = StatusCode String
instance showStatusCode :: Show StatusCode where
  show (StatusCode n) = "StatusCode " <> n

type Attribute a = Tuple2 String a
type Attributes a = List (Attribute a)

foreign import data SpanCtx :: Type
foreign import data Ctx :: Type
foreign import data Status :: Type

newtype TraceId = TraceId Int
newtype SpanId = SpanId Int

newtype TraceState = TraceState (List (Tuple2 String String))

foreign import registerTracer :: TracerName -> TracerVersion -> Effect Unit
foreign import registerApplicationTracer :: TracerName -> Effect Unit
foreign import setDefaultTracer :: Tracer -> Effect Unit
foreign import getDefaultTracer :: Effect Tracer
foreign import getTracer :: Effect Tracer
foreign import getTracer' :: TracerName -> Effect Tracer

foreign import status :: StatusCode -> String -> Status
