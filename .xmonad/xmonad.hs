{-# LANGUAGE MultiParamTypeClasses,DeriveDataTypeable, FlexibleInstances #-}


import Control.Applicative
import XMonad.Actions.CycleWS
import Control.Monad
import Data.Colour as DC
import Data.Colour.Names
import Data.Colour.SRGB
import Data.List
import Data.Function
import qualified Data.Map        as M
import qualified XMonad.Layout.Groups as G
import qualified XMonad.StackSet as W
import System.Exit
import System.FilePath
import XMonad
import XMonad.Actions.GridSelect
import XMonad.Actions.TopicSpace
import XMonad.Actions.SpawnOn
import XMonad.Layout.Groups.Helpers
import XMonad.Layout.LayoutOne
import XMonad.Util.ExtensibleState as XS

myTerminal      = "urxvtc -rv"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
myBorderWidth   = 3
myModMask       = mod4Mask


myNormalBorderColor  = "#222222"
myFocusedBorderColor = "#FFBF62"
wasd = [xK_w,xK_a,xK_s,xK_d,xK_q,xK_e]
hjkl = [xK_h,xK_j,xK_k,xK_l,xK_n,xK_p]
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [((modm .|. shiftMask, xK_Return), spawn =<< asks (terminal . config))]
    ++ 
    zipWith (\key cmd ->
            ((modm .|. shiftMask, key), sendMessage (G.ToEnclosing (SomeMessage cmd))))
          hjkl [Le, Do, Up, Ri]
    ++
    [((modm, xK_j)      , focusDown)
    ,((modm, xK_k)      , focusUp)
    ,((modm, xK_h)      , swapMaster ) -- make master
    ,((modm, xK_l)      , focusMaster ) -- goto master 
    ,((modm, xK_space)  , sendMessage NextLayout)
    ,((modm, xK_Return) , swapGroupMaster)
    ,((modm .|. shiftMask, xK_c), kill)
    ,((modm, xK_f), promptedGoto)
    ]
    ++
    zipWith (\key cmd ->
            ((modm, key), focusNumGroup cmd))
            wasd [0,2,3,1]
    ++
    zipWith (\key name ->
            ((modm .|. controlMask, key), switchTopic myTopicConfig name))
            wasd myTopics
    ++
    [((modm, xK_period) , splitGroup)
    ,((modm .|. shiftMask, xK_a), moveToGroupUp True)
    ,((modm .|. shiftMask, xK_d), moveToGroupDown True)
    ,((modm, xK_Tab), nextScreen)
    ]
    
        

        

-- -------------------[ Action.TopicSpace ]----------------

-- -----------------------------------------------------{{{

myTopics :: [Topic]
myTopics =  [ "a"
            , "primary"
            , "secondary"
            , "documentation"
            , "timebox"
            , "journal"
            , "media"
            , "work"
            , "system"
            ]
home = "/home/dave"

spawnVimIn dir fnames = do
        t <- asks (terminal . config)
        spawnHere $ "cd " ++ dir ++ " && " ++ t ++ " -e vim " ++ 
            (intercalate " " (map (dir </>) fnames))

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

wsgrid = gridselect gsConfig <=< asks $ 
    map (\x -> (x,x)) . workspaces . config
 
promptedGoto = wsgrid >>= flip whenJust (switchTopic myTopicConfig)
 
promptedShift = wsgrid >>= \x -> whenJust x $ \y -> windows (W.greedyView y . W.shift y)

myTopicConfig :: TopicConfig
myTopicConfig = defaultTopicConfig
    { topicDirs = M.fromList $
         [("a"             , home)
         ,("timebox"       , home </> ".timebox")
         ,("primary"       , home </> ".timebox/primary")
         ,("secondary"     , home </> ".timebox/secondary")
         ,("documentation" , home </> "notebook")
         ,("journal"       , home </> "notebook/journal")
         ,("media"         , home </> "data")
         ,("work"          , home)
         ,("system"        , home </> ".admin")
         ]
    , defaultTopicAction = const $ spawnShell >*>  4
    , defaultTopic = "a"
    , topicActions = M.fromList $
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

focusNumGroup n = do
        focusGroupMaster
        replicateM_ n focusGroupDown


displayNum n stack = let win = head $ drop n $ W.index stack
                         in W.focusWindow win stack


myLayout = G.group Full (LayoutOne (0.33,0.33)) ||| Full ||| tiled  where
    tiled   = Tall nmaster delta ratio
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
