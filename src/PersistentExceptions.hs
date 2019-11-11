module PersistentExceptions
  ( KeyNotFoundException(..)
  ) where

import           Control.Exception.Safe ( Exception )

{-
 - Exceptions
 -}
newtype KeyNotFoundException =
  KeyNotFoundException String
  deriving (Show)

instance Exception KeyNotFoundException
