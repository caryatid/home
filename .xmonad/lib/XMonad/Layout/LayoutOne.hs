{-# LANGUAGE DeriveDataTypeable, FlexibleInstances, GeneralizedNewtypeDeriving, MultiParamTypeClasses #-}

module XMonad.Layout.LayoutOne (LayoutOne(..)
                               ,Resizer(..)
                               ) where

import XMonad
import XMonad.StackSet
data Resizer = Up | Le | Do | Ri deriving (Show, Typeable, Enum)
instance Message Resizer
            
data LayoutOne a = LayoutOne { cursor :: (Rational,Rational)
                             }

                 deriving(Show, Read)

instance LayoutClass LayoutOne a where
        pureLayout (LayoutOne focus) r = arrange focus r . integrate
        pureMessage (LayoutOne (x,y)) m = 
            fmap resize (fromMessage m)
            where 
                  move = 0.02
                  resize Up = LayoutOne (x, max 0 $ y - move)
                  resize Do = LayoutOne (x, min 1 $ y + move)
                  resize Le = LayoutOne (max 0 $ x - move, y)
                  resize Ri = LayoutOne (min 1 $ x + move, y)

arrange :: (Rational, Rational) -> Rectangle -> [a] -> [(a, Rectangle)]
arrange (x,y) (Rectangle rx ry rw rh) st = zip st recs where
    (rxI, ryI, rwI, rhI) = (fromIntegral rx, fromIntegral ry
                           ,fromIntegral rw, fromIntegral rh)
    (xDim, yDim) = ((floor $ rwI * x), (floor $ rhI * y)) :: (Dimension, Dimension)
    (xPos, yPos) = ((fromIntegral xDim) + rxI, (fromIntegral yDim) + ryI) :: (Position, Position)
    recs = [Rectangle rx ry xDim yDim
           ,Rectangle xPos ry (rw - xDim) yDim
           ,Rectangle rx yPos xDim (rh - yDim)
           ,Rectangle xPos yPos (rw - xDim) (rh - yDim)
           ]

