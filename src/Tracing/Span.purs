module OpenTelemetry.Tracing.Span
  ( addEvent
  , endSpan
  , hexSpanId
  , hexTraceId
  , isRecording
  , setAttribute
  , setAttributes
  , setStatus
  , spanId
  , traceId
  , traceState
  , updateName
  )
  where

import Prelude

import Effect (Effect)
import OpenTelemetry (Attribute, SpanCtx, SpanId, SpanName, Status, TraceId, TraceState, Attributes)

foreign import traceId :: SpanCtx -> TraceId
foreign import hexTraceId :: SpanCtx -> String
foreign import spanId :: SpanCtx -> SpanId
foreign import hexSpanId :: SpanCtx -> String
foreign import traceState :: SpanCtx -> TraceState
foreign import isRecording :: SpanCtx -> Boolean
foreign import setAttribute :: SpanCtx -> String -> Attribute -> Effect Unit
foreign import setAttributes :: SpanCtx -> Attributes -> Effect Unit
foreign import addEvent :: forall r. SpanCtx -> String -> Record r -> Effect Unit
foreign import setStatus :: SpanCtx -> Status -> Effect Unit
foreign import updateName :: SpanCtx -> SpanName -> Effect Unit
foreign import endSpan :: SpanCtx -> Effect Unit
