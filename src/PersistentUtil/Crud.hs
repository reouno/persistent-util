{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs            #-}

module PersistentUtil.Crud
  ( selectList'
  , get'
  , getBy'
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
  => Pool backend
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
  -> Pool backend
  -> m (Maybe record)
get' k = runSqlPool $ get k

getBy' ::
     ( PersistStoreRead backend
     , PersistUniqueRead backend
     , IsPersistBackend backend
     , MonadUnliftIO m
     , PersistEntity record
     , PersistEntityBackend record ~ BaseBackend backend
     , BaseBackend backend ~ SqlBackend
     )
  => Unique record
  -> Pool backend
  -> m (Maybe (Entity record))
getBy' k = runSqlPool $ getBy k

insert' ::
     ( PersistStoreWrite backend
     , IsPersistBackend backend
     , MonadUnliftIO m
     , PersistEntity record
     , PersistEntityBackend record ~ BaseBackend backend
     , BaseBackend backend ~ SqlBackend
     )
  => record
  -> Pool backend
  -> m (Key record)
insert' r = runSqlPool $ insert r

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
  -> Pool backend
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
