module OpenTelemetry.Metrics.Meter where

import Prelude
import Data.Maybe (Maybe)
import Effect (Effect)
import Erl.Data.List (List)
import OpenTelemetry (Instrument, InstrumentName, InstrumentAttributes, Meter, Synchronous)

foreign import lookupInstrument :: forall s a m d. Meter -> InstrumentName s a m d -> Effect (Maybe (Instrument s a m d))

foreign import record :: forall a m d. Meter -> Instrument Synchronous a m d -> InstrumentAttributes -> d -> Effect Unit
