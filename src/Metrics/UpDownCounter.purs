module OpenTelemetry.Metrics.UpDownCounter
  ( Instrument
  , int
  , float
  ) where

import Effect (Effect)
import OpenTelemetry (Synchronous, Additive, NonMonotonic)
import OpenTelemetry as OpenTelemetry

type InstrumentName :: Type -> Type
type InstrumentName d = OpenTelemetry.InstrumentName Synchronous Additive NonMonotonic d

type Instrument :: Type -> Type
type Instrument d = OpenTelemetry.Instrument Synchronous Additive NonMonotonic d

int :: OpenTelemetry.Meter -> InstrumentName Int -> OpenTelemetry.InstrumentOptions -> Effect (Instrument Int)
int = create

float :: OpenTelemetry.Meter -> InstrumentName Number -> OpenTelemetry.InstrumentOptions -> Effect (Instrument Number)
float = create

foreign import create :: forall d. OpenTelemetry.Meter -> InstrumentName d -> OpenTelemetry.InstrumentOptions -> Effect (Instrument d)
