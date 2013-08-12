{-# LANGUAGE MultiParamTypeClasses,DeriveDataTypeable, FlexibleInstances #-}



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
import XMonad.Layout.WindowNavigation
import XMonad.Layout.PerWorkspace
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import XMonad.Util.ExtensibleState as XS
myTerminal      = "sakura"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
myBorderWidth   = 12
myModMask       = mod4Mask


myNormalBorderColor  = "#222222"
myFocusedBorderColor = "#0a8"
wasd = [xK_w,xK_a,xK_s,xK_d,xK_q,xK_e]
hjkl = [xK_h,xK_j,xK_k,xK_l,xK_n,xK_p]
myXPConfig = defaultXPConfig 
  { borderColor = "red"
  , font = "xft:Terminus:size=12"
  , height = 23
  }
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
------------------------------------------------------------
-- | mvtoTopic w x                                                 
-- | lastWorkspace
-- | bucketList popup
-----------------------------------------------------------------------
    [((modm .|. shiftMask, xK_Return), spawn =<< asks (terminal . config))
    -- | cycleWindowInCompartment x                                   
    ,((modm, xK_j)      , windows W.focusDown)
    ,((modm, xK_k)      , windows W.focusUp)
    ,((modm, xK_h)      , windows W.swapMaster ) -- make master
    ,((modm, xK_Return) , windows W.focusMaster )
    ,((modm, xK_t)      , withFocused $ windows . W.sink) 
    -- | changeLayout                                                  
    ,((modm, xK_space)  , sendMessage NextLayout)
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
    ,((modm, xK_Tab), nextScreen)
    ]
    ++
    -- | gotoTopic x                                                   
    zipWith (\key name ->
            ((modm .|. controlMask, key), switchTopic myTopicConfig name))
            wasd (tail myTopics)
    ++
    zipWith (\key name ->
            ((modm, key), sendMessage $ Go name)) wasd [U,L,D,R]

-- -------------------[ Action.TopicSpace ]----------------

-- -----------------------------------------------------{{{

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
home = "/home/dave"
{-
focusNumGroup n = do
        focusGroupMaster
        replicateM_ n focusGroupDown


displayNum n stack = let win = head $ drop n $ W.index stack
                         in W.focusWindow win stack
-}
spawnVimIn dir fnames = do
        t <- asks (terminal . config)
        spawnHere $ "cd " ++ dir ++ " && " ++ t ++ " -e vim " ++ 
            (unwords $ map (dir </>) fnames)

spawnVim fnames = do
        dir <- currentTopicDir myTopicConfig 
        spawnVimIn dir fnames
    

spawnShell = currentTopicDir myTopicConfig >>= spawnShellIn
spawnShellIn dir = do
    t <- asks (terminal . config)
    spawnHere $ "cd " ++ dir ++ " && " ++ t 
-- | TODO |--.----------------[ use tagbar shit  ]--------------------{{{
-- once working tagbar should help  organize code

-- | use tagbar shit 
-- ----------.------[ 9bc27280-bbfc-47c8-9afe-ed12a66aecb0 ]----------}}}

wsgrid = gridselect gsConfig <=< asks $ 
    map (\x -> (x,x)) . workspaces . config

 
promptedGoto = wsgrid >>= flip whenJust (switchTopic myTopicConfig)
 
promptedShift = wsgrid >>= \x -> whenJust x $ \y -> windows (W.greedyView y . W.shift y)

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
        spawnVim ["DaZip.hs"]
        spawnVim ["bucket_list.txt", "_README.txt"]
        dir <- currentTopicDir myTopicConfig
        t <- asks (terminal . config)
        spawnHere $  "cd " ++ dir ++ " && " ++ t ++ " -e ranger"
        spawnShell 


--------------------------------------------------------}}}

-- | TODO |--.-------------------[ gridselect ]-----------------------{{{

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

-- | gridselect
-- ----------.------[ 886a7bfc-bdd2-4574-b2a0-97da6b2d3829 ]----------}}}


myLayout = 
        Mirror (tiled) ||| tiled ||| Full where
                tiled   = Tall nmaster delta ratio
                {- tiled   = windowNavigation $ mosaic 2 [3,2] -}
                nmaster = 1
                ratio   = 1/2
                delta   = 3/100



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
-- | BUCKET | ----------------------------------------------------
-- per Compartment Layout
-- xmobar for each compartment
-- XMonad.Action.Plane
-- Border color for each workspace
