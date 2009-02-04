{-# LANGUAGE ForeignFunctionInterface #-}
{-# INCLUDE "foo.h" #-}
module Bar where

import Foreign
import Foreign.Ptr
import Foreign.ForeignPtr
import Foreign.C.Types

newtype CFoo = CFoo (Ptr CFoo)

foreign import ccall "init"
    c_init :: CInt -> CInt -> IO (Ptr CFoo)

foreign import ccall "wrapper"
    c_FooFunc :: (Ptr CFoo -> IO ()) -> IO (FunPtr (Ptr CFoo -> IO ()))

foreign import ccall "destroy"
    c_destroy :: Ptr CFoo -> IO ()

data Foo = Foo !(ForeignPtr CFoo) deriving Show

main = do Foo f <- fooInit 10 20
          finalizeForeignPtr f

fooInit :: Int -> Int -> IO Foo
fooInit x y = do f <- c_init (fromIntegral x) (fromIntegral y)
                 finalizer <- c_FooFunc c_destroy
                 p <- newForeignPtr finalizer f
                 return (Foo p)
