module OpenTelemetry.Tracing.Span where

import Prelude
import Effect (Effect)
import OpenTelemetry (SpanCtx, Attributes, Status, SpanName, TraceId, SpanId, TraceState)

foreign import traceId :: SpanCtx -> TraceId
foreign import spanId :: SpanCtx -> SpanId
foreign import traceState :: SpanCtx -> TraceState
foreign import isRecording :: SpanCtx -> Boolean
foreign import setAttribute :: forall a. SpanCtx -> String -> a -> Effect Unit
foreign import setAttributes :: forall a. SpanCtx -> Attributes a -> Effect Unit
foreign import addEvent :: forall a. SpanCtx -> String -> Attributes a -> Effect Unit
foreign import setStatus :: SpanCtx -> Status -> Effect Unit
foreign import updateName :: SpanCtx -> SpanName -> Effect Unit
foreign import endSpan :: SpanCtx -> Effect Unit
