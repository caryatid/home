-- @+leo-ver=5-thin
-- @+node:dave.20131113194236.1766: * @file xmonad.hs
-- @@language haskell
{-# LANGUAGE MultiParamTypeClasses,DeriveDataTypeable, FlexibleInstances #-}
-- @+<<imports>>
-- @+node:dave.20131113194236.1769: ** <<imports>>
import Control.Applicative
import Control.Monad
import Data.Colour as DC
import Data.Colour.Names
import Data.Colour.SRGB
import Data.Function
import Data.List
import qualified Data.Map        as M
import qualified XMonad.StackSet as W
import System.Exit
import System.FilePath
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.SpawnOn
import XMonad.Actions.TopicSpace
import XMonad.Layout
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LayoutOne
import XMonad.Layout.Mosaic
import XMonad.Layout.NoFrillsDecoration

import XMonad.Layout.PerWorkspace
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import XMonad.Util.ExtensibleState as XS
-- @-<<imports>>
-- @+others
-- @+node:dave.20131113194236.2061: ** settings

wasd = [xK_w,xK_a,xK_s,xK_d,xK_q,xK_e]
ijkl = [xK_i,xK_j,xK_k,xK_l,xK_u,xK_o]

home = "/home/dave"
-- @+node:dave.20131113194236.2063: *3* defaultConfig
myTerminal      = "sakura"
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
myBorderWidth   = 12
myModMask       = mod4Mask
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#0a8"

-- @+node:dave.20131113194236.2064: *3* Xmonad Prompt
myXPConfig = defaultXPConfig 
  { borderColor = "red"
  , font = "xft:Terminus:size=12"
  , height = 23
  }
-- @+node:dave.20131113194236.2065: *3* TopicSpace
myTopics :: [Topic]
myTopics =  [ "automatic"
            , "primary"
            , "secondary"
            , "timebox"
            , "internet"
            , "system"
            , "media"
            , "journal"
            , "work"
            ]
            
spawnShell = currentTopicDir myTopicConfig >>= spawnShellIn
spawnShellIn dir = do
    t <- asks (terminal . config)
    spawnHere $ "cd " ++ dir ++ " && " ++ t 
    
myTopicConfig :: TopicConfig
myTopicConfig = defaultTopicConfig
    { topicDirs = M.fromList 
         [("automatic" , home)
         ,("timebox"   , home </> ".timebox")
         ,("primary"   , home </> ".timebox/primary")
         ,("secondary" , home </> ".timebox/secondary")
         ,("internet"  , home </> "notebook")
         ,("journal"   , home </> "notebook/journal")
         ,("media"     , home </> "data")
         ,("work"      , home)
         ,("system"    , home </> ".admin")
         ]
    , defaultTopicAction = const $ spawnShell >*>  4
    , defaultTopic = "a"
    , topicActions = M.fromList 
         [("primary", primaryTools)
         ]
    }
primaryTools = do
        dir <- currentTopicDir myTopicConfig
        t <- asks (terminal . config)
        spawnHere $  "cd " ++ dir ++ " && " ++ t ++ " -e ranger"
        spawnShell 
-- @+node:dave.20131113194236.2066: *3* GridSelect
wsgrid = gridselect gsConfig <=< asks $ 
    map (\x -> (x,x)) . workspaces . config 
promptedGoto = wsgrid >>= flip whenJust (switchTopic myTopicConfig)
 
promptedShift = wsgrid >>= \x -> whenJust x $ \y -> windows (W.greedyView y . W.shift y)

gsConfig = defaultGSConfig { gs_navigate = fix $ \self ->
    let navKeyMap = M.mapKeys ((,) 0) $ M.fromList $
                [(xK_Escape, cancel)
                ,(xK_Return, select)
                ,(xK_slash , substringSearch self)]
           ++
            map (\(k,a) -> (k,a >> self))
                [(xK_Left  , move (-1,0 ))
                ,(xK_h     , move (-1,0 ))
                ,(xK_n     , move (-1,0 ))
                ,(xK_Right , move (1,0  ))
                ,(xK_l     , move (1,0  ))
                ,(xK_i     , move (1,0  ))
                ,(xK_Down  , move (0,1  ))
                ,(xK_j     , move (0,1  ))
                ,(xK_e     , move (0,1  ))
                ,(xK_Up    , move (0,-1 ))
                ,(xK_k     , move (0,-1 ))
                ,(xK_y     , move (-1,-1))
                ,(xK_m     , move (1,-1 ))
                ,(xK_space , setPos (0,0))
                ]
    in makeXEventhandler $ shadowWithKeymap navKeyMap (const self) }

-- @+node:dave.20131113194236.2067: *3* Layout
myLayout = 
        Mirror (tiled) ||| tiled ||| Full where
                tiled   = Tall nmaster delta ratio
                {- tiled   = windowNavigation $ mosaic 2 [3,2] -}
                nmaster = 1
                ratio   = 1/2
                delta   = 3/100
-- @+node:dave.20131113194236.1770: ** keybindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    ,((modm, xK_t)      , withFocused $ windows . W.sink)
    ]
    -- @+others
    -- @+node:dave.20131113194236.1771: *3* movement
        ++
        [((modm, xK_h)      , windows W.swapMaster ) -- make master
        ] 
        ++
        [((m .|. modm, k), windows $ f i) 
            | (i,k) <- zip (XMonad.workspaces conf) wasd
            , (f,m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
        ++
        [((shiftMask .|. modm, xK_Tab), shiftNextScreen >> nextScreen)]
    -- @+node:dave.20131113194236.1772: *3* focus
    ++
    [((modm, xK_j)      , windows W.focusDown)
    ,((modm, xK_k)      , windows W.focusUp)
    ,((modm, xK_Return) , windows W.focusMaster )
    ,((modm, xK_Tab)    , nextScreen)
    ]
    -- @+node:dave.20131113194236.2055: *3* layout/size/util
    -- @+node:dave.20131113194236.2056: *4* cycle-layout
    -- @+node:dave.20131113194236.2057: *4* larger/smaller main
    -- @+node:dave.20131113194236.2058: *4* runCommand
    -- @+node:dave.20131113194236.2059: *4* menus
    -- @+node:dave.20131113194236.2060: *4* term
    -- @-others
    -- | cycleWindowInCompartment x                                   
    ++

    -- | changeLayout                                                  
    [((modm, xK_space)  , sendMessage NextLayout)
    ,((modm .|. shiftMask, xK_h), sendMessage Shrink)
    ,((modm .|. shiftMask, xK_l), sendMessage Expand)
    ,((modm .|. shiftMask, xK_j), sendMessage Taller)
    ,((modm .|. shiftMask, xK_k), sendMessage Wider)
    ,((modm .|. shiftMask, xK_r), sendMessage Reset)
    ,((modm, xK_comma)  ,  sendMessage (IncMasterN (-1)))
    ,((modm, xK_period) ,  sendMessage (IncMasterN 1))
    -- | changeCompartmentLayout x                                     
    -- | TODO | Seems to fuck shit up 
    ,((modm .|. shiftMask, xK_c), kill)
    -- | chooseWindow  -- gridselect                                   
    ,((modm, xK_r), withSelectedWindow focus defaultGSConfig)
    -- | chooseTopic -- gridselect                                     
    ,((modm, xK_f), promptedGoto)
    -- | runCommand                                                    
    ,((modm, xK_x), runOrRaisePrompt myXPConfig)

    ]
    

-- @-others

myStartupHook = return ()

main = xmonad defaults
defaults = defaultConfig {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myTopics,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        keys               = myKeys,
        layoutHook         = myLayout,
        startupHook        = myStartupHook
    }






-- @-leo
