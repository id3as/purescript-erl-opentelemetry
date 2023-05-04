module OpenTelemetry.Metrics.ValueObserver where

import OpenTelemetry (Asynchronous, NonAdditive, NonMonotonic)
import OpenTelemetry as OpenTelemetry

type Definition :: Type -> Type
type Definition d = OpenTelemetry.InstrumentDefinition Asynchronous NonAdditive NonMonotonic d

type Instrument :: Type -> Type
type Instrument d = OpenTelemetry.Instrument Asynchronous NonAdditive NonMonotonic d

type Bound :: Type -> Type
type Bound d = OpenTelemetry.BoundInstrument Asynchronous NonAdditive NonMonotonic d

foreign import int :: OpenTelemetry.InstrumentName -> OpenTelemetry.InstrumentDescription -> OpenTelemetry.InstrumentUnit -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> OpenTelemetry.InstrumentDescription -> OpenTelemetry.InstrumentUnit -> Definition Number
