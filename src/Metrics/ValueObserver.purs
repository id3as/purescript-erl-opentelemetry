module OpenTelemetry.Metrics.ValueObserver where

import Prelude
import OpenTelemetry as OpenTelemetry
import OpenTelemetry (Asynchronous, NonAdditive, NonMonotonic)

type Definition d = OpenTelemetry.InstrumentDefinition Asynchronous NonAdditive NonMonotonic d
type Instrument d = OpenTelemetry.Instrument Asynchronous NonAdditive NonMonotonic d
type Bound d = OpenTelemetry.BoundInstrument Asynchronous NonAdditive NonMonotonic d

foreign import int :: OpenTelemetry.InstrumentName -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> Definition Number

