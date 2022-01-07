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
import Erl.Test.EUnit (TestF, runTests, setup, suite, test)
import Erl.Untagged.Union (type (|$|), type (|+|), Nil, Union, inj)
import OpenTelemetry (Attributes, SpanName(..), StatusCode(..), TracerName(..))
import OpenTelemetry as OpenTelemetry
import OpenTelemetry.Tracing.Span as Span
import OpenTelemetry.Tracing.Tracer as Tracer
import Test.Assert (assertEqual)

main :: Effect Unit
main = void $ runTests tests

-- These tests aren't to verify behaviour (which should be tested at the underlying library) but exercise the bindings
tests :: Free TestF Unit
tests = 
  setup startup do
    suite "tracer" do
      test "default module tracer" do
        _tracer <- OpenTelemetry.getTracer
        pure unit

      test "default tracer ??" do
        _tracer <- OpenTelemetry.getDefaultTracer
        pure unit

      test "named tracer/setDefaultTracer" do
        tracer <- OpenTelemetry.getTracer' $ TracerName "some name"
        OpenTelemetry.setDefaultTracer tracer
        pure unit
      
      test "application tracer" do
        _tracer <- OpenTelemetry.getApplicationTracer $ atom "test_main@ps"
        pure unit

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

      let attrs = (Map.empty :: Attributes)
                  # Map.insert "str" (inj "str")
                  # Map.insert "atom" (inj $ atom "atom")
                  # Map.insert "int" (inj 42)
                  # Map.insert "number" (inj 1.23)
                  # Map.insert "bool" (inj $ atom "true") -- bleurgh
                  # Map.insert "list" (inj ((inj "abc" :: Union |$| String |+| Atom |+| Int |+| Number |+| Nil) : inj 42 : nil)) -- BLEURGH

      let links = OpenTelemetry.link spanCtx Map.empty : nil
      Tracer.withSpan tracer (SpanName "myspan") (Tracer.defaultSpanStartOpts { attributes = attrs, links = links }) $ mkEffectFn1 \span -> do
        current <- Tracer.currentSpan
        assertEqual { actual: current, expected: Just span }


foreign import startup :: Effect Unit
