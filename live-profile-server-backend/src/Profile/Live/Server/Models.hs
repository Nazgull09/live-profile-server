{-|
Module      : Profile.Live.Server.Models
Description : Live server generic operations with DB
Copyright   : (c) Anton Gushcha, 2016
License     : BSD3
Maintainer  : ncrashed@gmail.com
Stability   : experimental
Portability : Portable
-}
module Profile.Live.Server.Models(
    doMigrations
  ) where

import Data.Proxy 
import Database.Persist.Sql
import Servant.API.REST.Derive.Server.Vinyl

import qualified Profile.Live.Server.API.Connection as Conn 
import qualified Servant.Server.Auth.Token.Model as Auth


-- | Perform safe migrations of database
doMigrations :: Int -> SqlPersistT IO ()
doMigrations strength = do
  runMigrationUnsafe $ do 
    Auth.migrateAll
    migrateVinyl (Proxy :: Proxy Conn.Connection)
  Auth.ensureAdmin strength "admin" "admin" "admin@localhost"