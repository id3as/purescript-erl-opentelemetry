module OpenTelemetry.Tracing.Tracer
  ( TracedFun
  , currentChildSpan
  , currentSpan
  , setCurrentChildSpan
  , setCurrentSpan
  , setStatus
  , startChildSpan
  , startLinkedSpan
  , startSpan
  , updateName
  , withSpan
  )
  where

import Prelude

import Data.Maybe (Maybe)
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Erl.Data.List (List)
import Erl.Data.Tuple (Tuple2)
import OpenTelemetry (Ctx, Link, SpanCtx, SpanName, Status, Tracer)

type TracedFun a
  = EffectFn1 SpanCtx a

foreign import startSpan :: Tracer -> SpanName -> Effect SpanCtx
foreign import startChildSpan :: Ctx -> Tracer -> SpanName -> Effect (Tuple2 SpanCtx Ctx)
foreign import startLinkedSpan :: Tracer -> SpanName -> List Link -> Effect SpanCtx

foreign import withSpan :: forall a. Tracer -> SpanName -> TracedFun a -> Effect a

foreign import setCurrentSpan :: Maybe SpanCtx -> Effect Unit
foreign import setCurrentChildSpan :: Ctx -> Maybe SpanCtx -> Effect Ctx
foreign import currentSpan :: Effect (Maybe SpanCtx)
foreign import currentChildSpan :: Ctx -> Effect (Maybe SpanCtx)

foreign import setStatus :: Status -> Effect Unit
foreign import updateName :: SpanName -> Effect Unit
