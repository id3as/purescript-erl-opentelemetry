module OpenTelemetry.Metrics.ValueObserver where

import OpenTelemetry as OpenTelemetry
import OpenTelemetry (Asynchronous, NonAdditive, NonMonotonic)

type Definition :: Type -> Type
type Definition d = OpenTelemetry.InstrumentDefinition Asynchronous NonAdditive NonMonotonic d

type Instrument :: Type -> Type
type Instrument d = OpenTelemetry.Instrument Asynchronous NonAdditive NonMonotonic d

type Bound :: Type -> Type
type Bound d = OpenTelemetry.BoundInstrument Asynchronous NonAdditive NonMonotonic d

foreign import int :: OpenTelemetry.InstrumentName -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> Definition Number

