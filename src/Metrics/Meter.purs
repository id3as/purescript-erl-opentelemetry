module OpenTelemetry.Metrics.Meter where

import Prelude 
import Effect (Effect)
import Erl.Data.List (List)
import Effect.Uncurried (EffectFn1)
import OpenTelemetry (InstrumentDefinition, Instrument, Label, BoundInstrument, Meter, Additive, Synchronous, Asynchronous, ObserverResult)

foreign import newInstrument :: forall s a m d. Meter -> InstrumentDefinition s a m d -> Effect (Instrument s a m d)
foreign import newInstruments :: forall s a m d. Meter -> List (InstrumentDefinition s a m d) -> Effect (Instrument s a m d)

foreign import bind :: forall a m d. Instrument Synchronous a m d -> List Label -> Effect (BoundInstrument Synchronous a m d)

foreign import record :: forall a m d. BoundInstrument Synchronous a m d -> d -> Effect Unit
foreign import record' :: forall a m d. Instrument Synchronous a m d -> d -> List Label -> Effect Unit

foreign import add :: forall m d. BoundInstrument Synchronous Additive m d -> d -> Effect Unit
foreign import add' :: forall m d. Instrument Synchronous Additive m d -> d -> List Label -> Effect Unit

foreign import registerObserver :: forall a m d. Instrument Asynchronous a m d -> EffectFn1 (ObserverResult a m d) Unit -> Effect Unit
foreign import observe :: forall a m d. ObserverResult a m d -> d -> List Label -> Effect Unit
