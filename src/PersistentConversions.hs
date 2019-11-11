{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs            #-}

module PersistentConversions
  ( sqlKey2Int
  , int2SqlKey
  , entity2Tuple
  ) where

import           Basement.IntegralConv ( int64ToInt, intToInt64 )
import           Database.Persist.Sql

sqlKey2Int :: ToBackendKey SqlBackend record => Key record -> Int
sqlKey2Int = int64ToInt . fromSqlKey

int2SqlKey :: ToBackendKey SqlBackend record => Int -> Key record
int2SqlKey = toSqlKey . intToInt64

entity2Tuple :: ToBackendKey SqlBackend b => Entity b -> (Int, b)
entity2Tuple entity = (sqlKey2Int . entityKey $ entity, entityVal entity)
