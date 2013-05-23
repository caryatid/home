{-
 - +|...................// view timebox pages that matter //---|{{{
 -  |DONE|  view timebox pages that matter
 -  | _README
 -  +--------
 -  Would like to have easy access/view of various timeview files
 -     should be a view for:
 -         primary, secondary, tertiary
 -         scratch, requisite, opportune
 - 
 -  | data
 -  +----------
 -     store Files 
 -     check vim for Files already open
 -     if they are not there then open
 - +|.............// 9744adf2-8855-477a-bc33-6ce5b70fc3e9 //---|}}}
 -}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}
import Shelly
import Prelude hiding (FilePath)
import Data.Text.Lazy as LT
import Data.Monoid
import System.IO hiding (FilePath)
import Control.Monad
import Data.Set
import Data.List.Utils
import Data.Maybe

default (LT.Text)

--  +|.......................................// data  //---|{{{
--   |TODO|  data 

fileGroups = [("goals", ["primary"
                        ,"secondary"
                        ,"tertiary"])
            ,("buckets", ["scratch.txt"
                         ,"requisite.txt"
                         ,"opportune.txt"])]


main = do 
        putStrLn "starting"
        let foo = "lame"
        shelly $ do
            echo "hello"
            echo foo
        putStrLn "stopping"
--  +|........// 98325379-58ac-4cd2-8455-26e646d9255c //---|}}}
