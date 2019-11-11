{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs            #-}

module PersistentCrud
  ( selectList'
  , get'
  , insert'
  , replace'
  , update'
  , delete'
  ) where

import           Conduit              ( MonadUnliftIO )
import           Data.Pool            ( Pool )
import           Database.Persist
import           Database.Persist.Sql

selectList' ::
     ( PersistQueryRead backend
     , IsPersistBackend backend
     , MonadUnliftIO m
     , PersistEntity record
     , PersistEntityBackend record ~ BaseBackend backend
     , BaseBackend backend ~ SqlBackend
     )
  => Data.Pool.Pool backend
  -> m [Entity record]
selectList' = runSqlPool $ selectList [] []

get' ::
     ( PersistStoreRead backend
     , IsPersistBackend backend
     , MonadUnliftIO m
     , PersistEntity record
     , PersistEntityBackend record ~ BaseBackend backend
     , BaseBackend backend ~ SqlBackend
     )
  => Key record
  -> Data.Pool.Pool backend
  -> m (Maybe record)
get' = runSqlPool . get

insert' ::
     ( PersistStoreWrite backend
     , IsPersistBackend backend
     , MonadUnliftIO m
     , PersistEntity record
     , PersistEntityBackend record ~ BaseBackend backend
     , BaseBackend backend ~ SqlBackend
     )
  => record
  -> Data.Pool.Pool backend
  -> m (Key record)
insert' = runSqlPool . insert

-- usually used as `update` method because of its simplicity
replace' ::
     ( PersistStoreWrite backend
     , IsPersistBackend backend
     , MonadUnliftIO m
     , PersistEntity record
     , PersistEntityBackend record ~ BaseBackend backend
     , BaseBackend backend ~ SqlBackend
     )
  => Key record
  -> record
  -> Data.Pool.Pool backend
  -> m ()
replace' k r = runSqlPool $ replace k r

-- see also `replace'` method
update' ::
     ( PersistStoreWrite backend
     , IsPersistBackend backend
     , MonadUnliftIO m
     , PersistEntity record
     , PersistEntityBackend record ~ BaseBackend backend
     , BaseBackend backend ~ SqlBackend
     )
  => Key record
  -> [Update record]
  -> Data.Pool.Pool backend
  -> m record
update' k us = runSqlPool $ updateGet k us

delete' ::
     ( PersistStoreWrite backend
     , IsPersistBackend backend
     , MonadUnliftIO m
     , PersistEntity record
     , PersistEntityBackend record ~ BaseBackend backend
     , BaseBackend backend ~ SqlBackend
     )
  => Key record
  -> Data.Pool.Pool backend
  -> m ()
delete' = runSqlPool . delete
