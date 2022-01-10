-- | Convenience aliases for creating attribute values, reducing need for type annotations compared to using the underlying untagged-union function
-- |
-- | Intended for qualified import e.g. `import Tracing.Attributes as Attributes`.
module Tracing.Attributes where

import Prelude

import Erl.Atom (Atom)
import Erl.Atom as Atom
import Erl.Data.List (List)
import Erl.Untagged.Union (type (|$|), type (|+|), Nil, Union, inj)
import OpenTelemetry (Attribute)

-- | A String attribute
string :: String -> Attribute
string = inj

-- | An Atom attribute
atom :: Atom -> Attribute
atom = inj

-- | A Boolean attribute, which is to say a restricted sort of atom.
boolean :: Boolean -> Attribute
boolean = inj <<< Atom.atom <<< if _ then "true" else "false"

-- | An Int attribute
int :: Int -> Attribute
int = inj

-- | A Number attribute. 
number :: Number -> Attribute
number = inj

-- | A list attribute. The members of the list should be constructed using the untagged-union `inj` directly
-- | ```purescript
-- | Attributes.list (inj "abc" : inj 42 : nil)
-- | ```
list :: List (Union |$| String |+| Atom |+| Int |+| Number |+| Nil) -> Attribute
list = inj
