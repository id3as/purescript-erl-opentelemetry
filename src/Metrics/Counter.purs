module OpenTelemetry.Metrics.Counter where

import Prelude
import OpenTelemetry as OpenTelemetry
import OpenTelemetry (Synchronous, Additive, Monotonic)

type Definition d = OpenTelemetry.InstrumentDefinition Synchronous Additive Monotonic d
type Instrument d = OpenTelemetry.Instrument Synchronous Additive Monotonic d
type Bound d = OpenTelemetry.BoundInstrument Synchronous Additive Monotonic d

foreign import int :: OpenTelemetry.InstrumentName -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> Definition Number

