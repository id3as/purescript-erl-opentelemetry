module OpenTelemetry.Metrics.ObservableCounter
  ( Instrument
  , InstrumentCallback
  , InstrumentName
  , int
  , float
  ) where

import Effect (Effect)
import OpenTelemetry (Additive, Asynchronous, Monotonic)
import OpenTelemetry as OpenTelemetry

type InstrumentName :: Type -> Type
type InstrumentName d = OpenTelemetry.InstrumentName Asynchronous Additive Monotonic d

type InstrumentCallback :: Type -> Type
type InstrumentCallback d = OpenTelemetry.InstrumentCallback Additive Monotonic d

type Instrument :: Type -> Type
type Instrument d = OpenTelemetry.Instrument Asynchronous Additive Monotonic d

int :: OpenTelemetry.Meter -> InstrumentName Int -> InstrumentCallback Int -> OpenTelemetry.InstrumentOptions -> Effect (Instrument Int)
int = create

float :: OpenTelemetry.Meter -> InstrumentName Number -> InstrumentCallback Number -> OpenTelemetry.InstrumentOptions -> Effect (Instrument Number)
float = create

foreign import create :: forall d. OpenTelemetry.Meter -> InstrumentName d -> InstrumentCallback d -> OpenTelemetry.InstrumentOptions -> Effect (Instrument d)
