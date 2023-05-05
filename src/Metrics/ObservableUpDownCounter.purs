module OpenTelemetry.Metrics.ObservableUpDownCounter
  ( Instrument
  , int
  , float
  ) where

import Effect (Effect)
import OpenTelemetry (Additive, Asynchronous, NonMonotonic, Synchronous)
import OpenTelemetry as OpenTelemetry

type InstrumentName :: Type -> Type
type InstrumentName d = OpenTelemetry.InstrumentName Asynchronous Additive NonMonotonic d

type InstrumentCallback :: Type -> Type
type InstrumentCallback d = OpenTelemetry.InstrumentCallback Additive NonMonotonic d

type Instrument :: Type -> Type
type Instrument d = OpenTelemetry.Instrument Asynchronous Additive NonMonotonic d

int :: OpenTelemetry.Meter -> InstrumentName Int -> InstrumentCallback Int -> OpenTelemetry.InstrumentOptions -> Effect (Instrument Int)
int = create

float :: OpenTelemetry.Meter -> InstrumentName Number -> InstrumentCallback Number -> OpenTelemetry.InstrumentOptions -> Effect (Instrument Number)
float = create

foreign import create :: forall d. OpenTelemetry.Meter -> InstrumentName d -> InstrumentCallback d -> OpenTelemetry.InstrumentOptions -> Effect (Instrument d)
