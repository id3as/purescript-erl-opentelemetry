module OpenTelemetry.Metrics.Counter where

import OpenTelemetry (Synchronous, Additive, Monotonic)
import OpenTelemetry as OpenTelemetry

type Definition :: Type -> Type
type Definition d = OpenTelemetry.InstrumentDefinition Synchronous Additive Monotonic d

type Instrument :: Type -> Type
type Instrument d = OpenTelemetry.Instrument Synchronous Additive Monotonic d

type Bound :: Type -> Type
type Bound d = OpenTelemetry.BoundInstrument Synchronous Additive Monotonic d

foreign import int :: OpenTelemetry.InstrumentName -> OpenTelemetry.InstrumentDescription -> OpenTelemetry.InstrumentUnit -> Definition Int
foreign import float :: OpenTelemetry.InstrumentName -> OpenTelemetry.InstrumentDescription -> OpenTelemetry.InstrumentUnit -> Definition Number
