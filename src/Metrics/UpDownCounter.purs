module OpenTelemetry.Metrics.UpDownCounter where

import Prelude
import OpenTelemetry as OpenTelemetry
import OpenTelemetry (Synchronous, Additive, NonMonotonic)

type Definition d = OpenTelemetry.InstrumentDefinition Synchronous Additive NonMonotonic d
type Instrument d = OpenTelemetry.Instrument Synchronous Additive NonMonotonic d
type Bound d = OpenTelemetry.BoundInstrument Synchronous Additive NonMonotonic d

foreign import int :: OpenTelemetry.InstrumentName -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> Definition Number

