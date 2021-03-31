module OpenTelemetry.Metrics.SumObserver where

import OpenTelemetry as OpenTelemetry
import OpenTelemetry (Asynchronous, Additive, Monotonic)

type Definition :: Type -> Type
type Definition d = OpenTelemetry.InstrumentDefinition Asynchronous Additive Monotonic d

type Instrument :: Type -> Type
type Instrument d = OpenTelemetry.Instrument Asynchronous Additive Monotonic d

type Bound :: Type -> Type
type Bound d = OpenTelemetry.BoundInstrument Asynchronous Additive Monotonic d

foreign import int :: OpenTelemetry.InstrumentName -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> Definition Number

