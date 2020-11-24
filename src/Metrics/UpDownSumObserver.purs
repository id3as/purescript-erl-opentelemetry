module OpenTelemetry.Metrics.UpDownSumObserver where

import Prelude
import OpenTelemetry as OpenTelemetry
import OpenTelemetry (Asynchronous, Additive, NonMonotonic)

type Definition d = OpenTelemetry.InstrumentDefinition Asynchronous Additive NonMonotonic d
type Instrument d = OpenTelemetry.Instrument Asynchronous Additive NonMonotonic d
type Bound d = OpenTelemetry.BoundInstrument Asynchronous Additive NonMonotonic d

foreign import int :: OpenTelemetry.InstrumentName -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> Definition Number

