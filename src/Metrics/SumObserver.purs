module OpenTelemetry.Metrics.SumObserver where

import Prelude
import OpenTelemetry as OpenTelemetry
import OpenTelemetry (Asynchronous, Additive, Monotonic)

type Definition d = OpenTelemetry.InstrumentDefinition Asynchronous Additive Monotonic d
type Instrument d = OpenTelemetry.Instrument Asynchronous Additive Monotonic d
type Bound d = OpenTelemetry.BoundInstrument Asynchronous Additive Monotonic d

foreign import int :: OpenTelemetry.InstrumentName -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> Definition Number

