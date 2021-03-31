module OpenTelemetry.Metrics.UpDownSumObserver where

import OpenTelemetry as OpenTelemetry
import OpenTelemetry (Asynchronous, Additive, NonMonotonic)

type Definition :: Type -> Type
type Definition d = OpenTelemetry.InstrumentDefinition Asynchronous Additive NonMonotonic d

type Instrument :: Type -> Type
type Instrument d = OpenTelemetry.Instrument Asynchronous Additive NonMonotonic d

type Bound :: Type -> Type
type Bound d = OpenTelemetry.BoundInstrument Asynchronous Additive NonMonotonic d

foreign import int :: OpenTelemetry.InstrumentName -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> Definition Number

