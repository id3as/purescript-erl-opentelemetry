module OpenTelemetry.Metrics.UpDownCounter where

import OpenTelemetry (Synchronous, Additive, NonMonotonic)
import OpenTelemetry as OpenTelemetry

type Definition :: Type -> Type
type Definition d = OpenTelemetry.InstrumentDefinition Synchronous Additive NonMonotonic d

type Instrument :: Type -> Type
type Instrument d = OpenTelemetry.Instrument Synchronous Additive NonMonotonic d

type Bound :: Type -> Type
type Bound d = OpenTelemetry.BoundInstrument Synchronous Additive NonMonotonic d

foreign import int :: OpenTelemetry.InstrumentName -> OpenTelemetry.InstrumentDescription -> OpenTelemetry.InstrumentUnit -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> OpenTelemetry.InstrumentDescription -> OpenTelemetry.InstrumentUnit -> Definition Number
