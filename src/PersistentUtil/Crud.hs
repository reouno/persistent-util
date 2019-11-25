{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs            #-}

module PersistentUtil.Crud
  ( selectList'
  , get'
  , insert'
  , replace'
  , update'
  , delete'
  ) where

import           Conduit                   ( MonadUnliftIO )
import           Data.Pool                 ( Pool )
import           Database.Persist
import           Database.Persist.Sql

import           PersistentUtil.Conversion ( entity2Tuple )

selectList' ::
     ( PersistQueryRead backend
     , IsPersistBackend backend
     , ToBackendKey SqlBackend b
     , MonadUnliftIO f
     , PersistEntityBackend b ~ BaseBackend backend
     , BaseBackend backend ~ SqlBackend
     )
  => Pool backend
  -> f [(Int, b)]
selectList' pool = map entity2Tuple <$> runSqlPool (selectList [] []) pool

get' ::
     ( PersistStoreRead backend
     , IsPersistBackend backend
     , ToBackendKey SqlBackend b1
     , MonadUnliftIO f
     , PersistEntity (Entity b1)
     , BaseBackend backend ~ SqlBackend
     , PersistEntityBackend (Entity b1) ~ BaseBackend backend
     )
  => Key (Entity b1)
  -> Pool backend
  -> f (Maybe (Int, b1))
get' k pool = fmap entity2Tuple <$> runSqlPool (get k) pool

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
