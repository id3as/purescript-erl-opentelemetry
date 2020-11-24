module OpenTelemetry.Metrics.ValueRecorder where

import Prelude
import OpenTelemetry as OpenTelemetry
import OpenTelemetry (Synchronous, NonAdditive, NonMonotonic)

type Definition d = OpenTelemetry.InstrumentDefinition Synchronous NonAdditive NonMonotonic d
type Instrument d = OpenTelemetry.Instrument Synchronous NonAdditive NonMonotonic d
type Bound d = OpenTelemetry.BoundInstrument Synchronous NonAdditive NonMonotonic d

foreign import int :: OpenTelemetry.InstrumentName -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> Definition Number

