module OpenTelemetry.Tracing.Tracer where

import Prelude

import OpenTelemetry (Tracer, SpanName, Ctx, SpanCtx, Status, Attributes)
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Erl.Data.Tuple (Tuple2)

type TracedFun a = EffectFn1 SpanCtx a

foreign import startSpan :: Tracer -> SpanName -> Effect SpanCtx
foreign import startChildSpan :: SpanCtx -> Tracer -> SpanName -> Effect (Tuple2 SpanCtx Ctx)
foreign import endSpan :: Effect Unit

foreign import withSpan :: forall a. Tracer -> SpanName -> TracedFun a -> Effect a

foreign import setCurrentSpan :: SpanCtx -> Effect Unit
foreign import setCurrentChildSpan :: Ctx -> SpanCtx -> Effect Ctx
foreign import currentSpan :: Effect SpanCtx
foreign import currentChildSpan :: Ctx -> Effect SpanCtx


foreign import setAttribute :: forall a. String -> a -> Effect Unit
foreign import setAttributes :: forall a. Attributes a -> Effect Unit
foreign import addEvent :: forall a. String -> Attributes a -> Effect Unit
foreign import setStatus :: Status -> Effect Unit
foreign import updateName :: SpanName -> Effect Unit
