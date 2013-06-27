{-# LANGUAGE DeriveDataTypeable, FlexibleInstances, GeneralizedNewtypeDeriving, MultiParamTypeClasses #-}

module XMonad.Layout.LayoutOne (LayoutOne(..)
                               ,Resizer(..)
                               ,onlyTheLonely
                               ) where

import XMonad
import XMonad.StackSet

data Resizer = Up | Le | Do | Ri deriving (Show, Typeable, Enum)
instance Message Resizer

-- | LayoutOne -----------------------------------------------            
data LayoutOne a = LayoutOne { cursor :: (Rational,Rational)
                             }

                 deriving(Show, Read)

instance LayoutClass LayoutOne a where
--        pureLayout (LayoutOne focus) r = arrange focus r . (onlyTheLonely 0 containers) . integrate
         pureLayout (LayoutOne focus) r = arrange focus r .  integrate
         pureMessage (LayoutOne (x,y)) m = 
             fmap resize (fromMessage m)
             where 
                   move = 0.02
                   resize Up = LayoutOne (x, max 0 $ y - move)
                   resize Do = LayoutOne (x, min 1 $ y + move)
                   resize Le = LayoutOne (max 0 $ x - move, y)
                   resize Ri = LayoutOne (min 1 $ x + move, y)

containers = [0,0,0,0]
test x = f x 
        where
            f = (3x)
onlyTheLonely i nx@(n:ns) (w:ws)  
        | n == i = w:onlyTheLonely 0 ns ws 
        | otherwise = onlyTheLonely (i+1) nx ws 
onlyTheLonely _ [] _  = []
onlyTheLonely _ _ []  = []
             
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
-- | Panel  -----------------------------------------------            
--      Idea is viewports with different windows in them. 
--      This is similar to XMonad.Layout.Groups.  The difference
--      is based around representation. Groups creates its own zipper 
--      representations of the windows in each group.  Panel overlay's 
--      the group concept on top of the regular StackSet.integrate return

-- | BUCKET | ------------------------------------------
{- 
-- | TODO | Check out get list of indexes
    onlyTheLonely gets a items from a list by index derived from 
    a list of indexes -- there must be a better way
-}

   