module OpenTelemetry.Tracing.Tracer where

import Prelude
import OpenTelemetry (Tracer, SpanName, Ctx, SpanCtx, Status, Attributes)
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Erl.Data.Tuple (Tuple2)
import Data.Maybe (Maybe)

type TracedFun a
  = EffectFn1 SpanCtx a

foreign import startSpan :: Tracer -> SpanName -> Effect SpanCtx
foreign import startChildSpan :: SpanCtx -> Tracer -> SpanName -> Effect (Tuple2 SpanCtx Ctx)

foreign import withSpan :: forall a. Tracer -> SpanName -> TracedFun a -> Effect a

foreign import setCurrentSpan :: Maybe SpanCtx -> Effect Unit
foreign import setCurrentChildSpan :: Ctx -> Maybe SpanCtx -> Effect Ctx
foreign import currentSpan :: Effect (Maybe SpanCtx)
foreign import currentChildSpan :: Ctx -> Effect (Maybe SpanCtx)

foreign import setStatus :: Status -> Effect Unit
foreign import updateName :: SpanName -> Effect Unit
