module Test.Main
  ( main
  , tests
  )
  where

import Prelude

import Control.Monad.Free (Free)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Uncurried (mkEffectFn1)
import Erl.Atom (Atom, atom)
import Erl.Data.List (nil, (:))
import Erl.Data.Map as Map
import Erl.Data.Tuple (tuple2)
import Erl.Test.EUnit (TestF, runTests, setup, suite, test)
import Erl.Untagged.Union (type (|$|), type (|+|), Nil, Union, inj)
import OpenTelemetry (Attributes, SpanName(..), StatusCode(..), TracerName(..), TracerVersion(..))
import OpenTelemetry as OpenTelemetry
import OpenTelemetry.Tracing.Baggage as Baggage
import OpenTelemetry.Tracing.Ctx as Ctx
import OpenTelemetry.Tracing.Span as Span
import OpenTelemetry.Tracing.Tracer as Tracer
import Test.Assert (assertEqual)
import Tracing.Attributes as Attributes

main :: Effect Unit
main = void $ runTests tests

-- These tests aren't to verify behaviour (which should be tested at the underlying library) but exercise the bindings
tests :: Free TestF Unit
tests = 
  setup startup do
    suite "tracer" do
      test "default tracer" do
        _tracer <- OpenTelemetry.getTracer
        pure unit

      test "named tracer/setDefaultTracer" do
        tracer <- OpenTelemetry.getNamedTracer $ TracerName "some name"
        OpenTelemetry.setDefaultTracer tracer
        pure unit

      test "versioned tracer" do
        tracer <- OpenTelemetry.getVersionedTracer (TracerName "some name") (TracerVersion "1.0.0") "not_uri"
        OpenTelemetry.setDefaultTracer tracer
        pure unit
      
      test "application tracer" do
        _tracer <- OpenTelemetry.getApplicationTracer $ atom "test_main@ps"
        pure unit

    suite "span" do
      test "set a span" do
        tracer <- OpenTelemetry.getTracer
        spanCtx <- Tracer.startSpan tracer (SpanName "myspan") Tracer.defaultSpanStartOpts
        Tracer.setCurrentSpan $ Just spanCtx
        current <- Tracer.currentSpan
        Span.endSpan spanCtx
        assertEqual { actual: current, expected: Just spanCtx }

      test "with span" do
        tracer <- OpenTelemetry.getTracer
        Tracer.withSpan tracer (SpanName "myspan") Tracer.defaultSpanStartOpts $ mkEffectFn1 \span -> do
          current <- Tracer.currentSpan
          assertEqual { actual: current, expected: Just span }
        current <- Tracer.currentSpan
        assertEqual { actual: current, expected: Nothing }

      test "modify span" do
        tracer <- OpenTelemetry.getTracer
        spanCtx <- Tracer.startSpan tracer (SpanName "myspan") Tracer.defaultSpanStartOpts
        Span.updateName spanCtx (SpanName "who knows if this does anything")      
        Span.setAttribute spanCtx "attribute" (inj "value")
        Span.setAttribute spanCtx "another_attribute" (inj 42)
        Span.setStatus spanCtx $ OpenTelemetry.status (StatusCode "ok") "msg"
        Span.setStatus spanCtx $ OpenTelemetry.status (StatusCode "bad_status_code") "msg"

      test "attributes/links" do
        tracer <- OpenTelemetry.getTracer
        spanCtx <- Tracer.startSpan tracer (SpanName "other_span") Tracer.defaultSpanStartOpts

        let attrs = Map.empty
                    # Map.insert "str" (Attributes.string "str")
                    # Map.insert "atom" (Attributes.atom $ atom "atom")
                    # Map.insert "int" (Attributes.int 42)
                    # Map.insert "number" (Attributes.number 1.23)
                    # Map.insert "bool" (Attributes.boolean true)
                    # Map.insert "list" (Attributes.list (inj "abc" : inj 42 : nil))

        let links = OpenTelemetry.link spanCtx Map.empty : nil
        Tracer.withSpan tracer (SpanName "myspan") (Tracer.defaultSpanStartOpts { attributes = attrs, links = links }) $ mkEffectFn1 \span -> do
          current <- Tracer.currentSpan
          assertEqual { actual: current, expected: Just span }
          Span.setAttributes span attrs
          Span.setAttribute span "new_attr" (Attributes.int 1)
    
    setup Ctx.clear do
      suite "ctx" do
        test "implicit ctx" do
          Ctx.setValue "key" 42
          result <- Ctx.getValue "key"
          assertEqual { actual: result, expected: Just 42 }
          result' :: Maybe Int <- Ctx.getValue "key2"
          assertEqual { actual: result', expected: Nothing }

        test "implicit ctx clear" do
          Ctx.setValue "key" 42
          Ctx.clear
          result :: Maybe Int <- Ctx.getValue "key"
          assertEqual { actual: result, expected: Nothing }

        test "implicit ctx remove" do
          Ctx.setValue "key" 42
          Ctx.remove "key"
          result :: Maybe Int <- Ctx.getValue "key"
          assertEqual { actual: result, expected: Nothing }

        test "explicit ctx" do
          -- Also known as "it's a map"
          let ctx = Ctx.new
              ctx' = Ctx.setValueInCtx ctx "key" 42
              result = Ctx.getValueInCtx ctx' "key" 0
          assertEqual { actual: result, expected: 42 }
          let ctx2 = Ctx.clearCtx ctx'
              result2 = Ctx.getValueInCtx ctx2 "key" 0
          assertEqual { actual: result2, expected: 0 }

        test "explicit ctx clear" do
          let ctx = Ctx.clearCtx $ Ctx.setValueInCtx Ctx.new "key" 42
              result = Ctx.getValueInCtx ctx "key" 0
          assertEqual { actual: result, expected: 0 }

        test "explicit ctx remove" do
          let ctx = flip Ctx.removeInCtx "key" $ Ctx.setValueInCtx Ctx.new "key" 42
              result = Ctx.getValueInCtx ctx "key" 0
          assertEqual { actual: result, expected: 0 }

    setup Ctx.clear do
      suite "baggage" do
        test "implicit ctx baggage" do
          let bag = Baggage.create $ tuple2 "k1" "v1" : tuple2 "k2" "v2" : nil
          Baggage.set bag
          Baggage.setValue "k3" "v3"
          res <- Baggage.getAll
          let actual = Baggage.read res "k1"
          assertEqual { actual, expected: Just "v1" }
          assertEqual { actual: Baggage.read res "k3", expected: Just "v3" }
          assertEqual { actual: Baggage.read res "badkey", expected: Nothing }

          pure unit

        test "explicit ctx baggage" do
          let bag = Baggage.create $ tuple2 "k1" "v1" : tuple2 "k2" "v2" : nil
              ctx = Baggage.setInCtx Ctx.new bag
              ctx' = Baggage.setValueInCtx ctx "k3" "v3"
              res = Baggage.getAllInCtx ctx'
          assertEqual { actual: Baggage.read res "k1", expected: Just "v1" }
          assertEqual { actual: Baggage.read res "k3", expected: Just "v3" }
          assertEqual { actual: Baggage.read res "badkey", expected: Nothing }

          pure unit


foreign import startup :: Effect Unit
