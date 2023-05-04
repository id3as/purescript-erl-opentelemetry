module OpenTelemetry.Metrics.ValueRecorder where

import OpenTelemetry (Synchronous, NonAdditive, NonMonotonic)
import OpenTelemetry as OpenTelemetry

type Definition d = OpenTelemetry.InstrumentDefinition Synchronous NonAdditive NonMonotonic d
type Instrument d = OpenTelemetry.Instrument Synchronous NonAdditive NonMonotonic d
type Bound d = OpenTelemetry.BoundInstrument Synchronous NonAdditive NonMonotonic d

foreign import int :: OpenTelemetry.InstrumentName -> OpenTelemetry.InstrumentDescription -> OpenTelemetry.InstrumentUnit -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> OpenTelemetry.InstrumentDescription -> OpenTelemetry.InstrumentUnit -> Definition Number
