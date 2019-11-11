{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_persistent_util (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/leo/src/hsproject/persistent-util/.stack-work/install/x86_64-osx/7fbd7ab25b776184a25dca3644ca9487ae59b1eabe8500e9d60ee04f58152701/8.6.5/bin"
libdir     = "/Users/leo/src/hsproject/persistent-util/.stack-work/install/x86_64-osx/7fbd7ab25b776184a25dca3644ca9487ae59b1eabe8500e9d60ee04f58152701/8.6.5/lib/x86_64-osx-ghc-8.6.5/persistent-util-0.1.0.0-kX21EIRbDn4sAuc5f73SN"
dynlibdir  = "/Users/leo/src/hsproject/persistent-util/.stack-work/install/x86_64-osx/7fbd7ab25b776184a25dca3644ca9487ae59b1eabe8500e9d60ee04f58152701/8.6.5/lib/x86_64-osx-ghc-8.6.5"
datadir    = "/Users/leo/src/hsproject/persistent-util/.stack-work/install/x86_64-osx/7fbd7ab25b776184a25dca3644ca9487ae59b1eabe8500e9d60ee04f58152701/8.6.5/share/x86_64-osx-ghc-8.6.5/persistent-util-0.1.0.0"
libexecdir = "/Users/leo/src/hsproject/persistent-util/.stack-work/install/x86_64-osx/7fbd7ab25b776184a25dca3644ca9487ae59b1eabe8500e9d60ee04f58152701/8.6.5/libexec/x86_64-osx-ghc-8.6.5/persistent-util-0.1.0.0"
sysconfdir = "/Users/leo/src/hsproject/persistent-util/.stack-work/install/x86_64-osx/7fbd7ab25b776184a25dca3644ca9487ae59b1eabe8500e9d60ee04f58152701/8.6.5/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "persistent_util_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "persistent_util_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "persistent_util_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "persistent_util_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "persistent_util_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "persistent_util_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
