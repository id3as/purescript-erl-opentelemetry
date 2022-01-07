module OpenTelemetry.Tracing.Tracer
  ( SpanStartOpts
  , TracedFun
  , currentChildSpan
  , currentSpan
  , defaultSpanStartOpts
  , setCurrentChildSpan
  , setCurrentSpan
  , startChildSpan
  , startSpan
  , withSpan
  ) where

import Prelude
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Erl.Atom (Atom, atom)
import Erl.Data.List (List, nil)
import Erl.Data.Map as Map
import Erl.Data.Tuple (Tuple2)
import OpenTelemetry (Ctx, Link, SpanCtx, SpanName, Tracer)
import OpenTelemetry.Tracing (Attributes, SpanKind(..), Timestamp, timestamp)

type TracedFun a
  = EffectFn1 SpanCtx a

type SpanStartOpts
  = { attributes :: Attributes
    , links :: List Link
    , isRecording :: Boolean
    , startTime :: Maybe Timestamp
    , kind :: SpanKind
    }

defaultSpanStartOpts ∷ SpanStartOpts
defaultSpanStartOpts =
  { attributes: Map.empty
  , links: nil
  , isRecording: true
  , startTime: Nothing
  , kind: SpanKindInternal
  }

foreign import startSpanImpl :: Tracer -> SpanName -> InternalSpanStartOpts -> Effect SpanCtx

startSpan :: Tracer -> SpanName -> SpanStartOpts -> Effect SpanCtx
startSpan tracer name opts =
  startSpanImpl tracer name =<< convertOpts opts

foreign import startChildSpanImpl :: Ctx -> Tracer -> SpanName -> InternalSpanStartOpts -> Effect (Tuple2 SpanCtx Ctx)

startChildSpan :: Tracer -> SpanName -> SpanStartOpts -> Effect SpanCtx
startChildSpan tracer name opts =
  startSpanImpl tracer name =<< convertOpts opts

foreign import withSpanImpl :: forall a. Tracer -> SpanName -> InternalSpanStartOpts -> TracedFun a -> Effect a

withSpan :: forall a. Tracer -> SpanName -> SpanStartOpts -> TracedFun a -> Effect a
withSpan tracer name opts fn =
  flip (withSpanImpl tracer name) fn =<< convertOpts opts

foreign import setCurrentSpan :: Maybe SpanCtx -> Effect Unit
foreign import setCurrentChildSpan :: Ctx -> Maybe SpanCtx -> Effect Ctx
foreign import currentSpan :: Effect (Maybe SpanCtx)
foreign import currentChildSpan :: Ctx -> Effect (Maybe SpanCtx)

type InternalSpanStartOpts
  = { attributes :: Attributes
    , links :: List Link
    , is_recording :: Boolean
    , start_time :: Timestamp
    , kind :: Atom
    }

convertOpts :: SpanStartOpts -> Effect InternalSpanStartOpts
convertOpts { attributes, links, isRecording, startTime, kind } = do
  -- If we *omit* the timestamp from the map otel would do the same thing
  start <- maybe timestamp pure startTime
  pure
    $
      { attributes
      , links
      , is_recording: isRecording
      , start_time: start
      , kind:
          case kind of
            SpanKindInternal -> atom "internal"
            SpanKindServer -> atom "server"
            SpanKindClient -> atom "client"
            SpanKindConsumer -> atom "consumer"
            SpanKindProducer -> atom "producer"
      }
