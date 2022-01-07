module OpenTelemetry.Tracing
  ( Attribute
  , Attributes
  , Ctx
  , Link
  , SpanCtx
  , SpanId(..)
  , SpanKind(..)
  , SpanName(..)
  , Status
  , StatusCode(..)
  , Timestamp
  , TraceId(..)
  , TraceState(..)
  , Tracer
  , TracerName(..)
  , TracerVersion(..)
  , getApplicationTracer
  , getDefaultTracer
  , getTracer
  , getTracer'
  , getTracerVersioned
  , link
  , setDefaultTracer
  , status
  , timestamp
  , timestampToNano
  )
  where

import Prelude

import Data.Tuple.Nested (Tuple2)
import Effect (Effect)
import Erl.Atom (Atom)
import Erl.Data.List (List)
import Erl.Data.Map (Map)
import Erl.Untagged.Union (type (|$|), type (|+|), Nil, Union)
import Unsafe.Reference (unsafeRefEq)

foreign import data Tracer :: Type

newtype TracerName
  = TracerName String
instance showTracerName :: Show TracerName where
  show (TracerName n) = "TracerName " <> n
derive newtype instance Eq TracerName

newtype TracerVersion
  = TracerVersion String
instance showTracerVersion :: Show TracerVersion where
  show (TracerVersion n) = "TracerVersion " <> n

newtype SpanName
  = SpanName String
instance showSpanName :: Show SpanName where
  show (SpanName n) = "SpanName " <> n
derive newtype instance Eq SpanName

newtype StatusCode
  = StatusCode String
instance showStatusCode :: Show StatusCode where
  show (StatusCode n) = "StatusCode " <> n
derive newtype instance Eq StatusCode

type Attribute
  = Union
    |$|
    String
    |+|
    Atom
    |+|
    Int
    |+|
    Number
    {- |+| Boolean -}
    |+|
    List (Union |$| String |+| Atom |+| Int |+| Number {- |+| Boolean -} |+| Nil)
    |+|
    Nil

type Attributes
  = Map String Attribute

foreign import data SpanCtx :: Type

instance Eq SpanCtx where
  eq span1 span2 = unsafeRefEq span1 span2

instance Show SpanCtx where
  show = showSpanCtx

foreign import showSpanCtx :: SpanCtx -> String

foreign import data Ctx :: Type
foreign import data Status :: Type

foreign import data Link :: Type

newtype TraceId
  = TraceId Int

derive newtype instance Eq TraceId

newtype SpanId
  = SpanId Int

derive newtype instance Eq SpanId

newtype TraceState
  = TraceState (List (Tuple2 String String))

-- | Set default tracer
foreign import setDefaultTracer :: Tracer -> Effect Unit

-- | Get default tracer
foreign import getDefaultTracer :: Effect Tracer

-- | Get module tracer
foreign import getTracer :: Effect Tracer

-- | Get named tracer
foreign import getTracer' :: TracerName -> Effect Tracer

-- | Get tracer specifying version and schema URL
foreign import getTracerVersioned :: TracerName -> TracerVersion -> String -> Effect Tracer

-- | Get application tracer for specified module
foreign import getApplicationTracer :: Atom -> Effect Tracer

foreign import status :: StatusCode -> String -> Status

-- | Construct a Link
foreign import link :: SpanCtx -> Attributes -> Link

data SpanKind
  = SpanKindInternal
  | SpanKindServer
  | SpanKindClient
  | SpanKindProducer
  | SpanKindConsumer
derive instance Eq SpanKind

foreign import data Timestamp :: Type

instance Eq Timestamp where
  eq t1 t2 = unsafeRefEq t1 t2

foreign import timestamp :: Effect Timestamp

foreign import timestampToNano :: Timestamp -> Int
