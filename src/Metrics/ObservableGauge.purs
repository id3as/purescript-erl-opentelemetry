module OpenTelemetry.Metrics.ObservableGauge
  ( Instrument
  , int
  , float
  , create
  , InstrumentName
  , InstrumentCallback
  ) where

import Effect (Effect)
import OpenTelemetry (Asynchronous, NonAdditive, NonMonotonic)
import OpenTelemetry as OpenTelemetry

type InstrumentName :: Type -> Type
type InstrumentName d = OpenTelemetry.InstrumentName Asynchronous NonAdditive NonMonotonic d

type InstrumentCallback :: Type -> Type
type InstrumentCallback d = OpenTelemetry.InstrumentCallback NonAdditive NonMonotonic d

type Instrument :: Type -> Type
type Instrument d = OpenTelemetry.Instrument Asynchronous NonAdditive NonMonotonic d

int :: OpenTelemetry.Meter -> InstrumentName Int -> InstrumentCallback Int -> OpenTelemetry.InstrumentOptions -> Effect (Instrument Int)
int = create

float :: OpenTelemetry.Meter -> InstrumentName Number -> InstrumentCallback Number -> OpenTelemetry.InstrumentOptions -> Effect (Instrument Number)
float = create

foreign import create :: forall d. OpenTelemetry.Meter -> InstrumentName d -> InstrumentCallback d -> OpenTelemetry.InstrumentOptions -> Effect (Instrument d)
