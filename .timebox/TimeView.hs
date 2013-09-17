{-
    
    run command with argument for level and duration
    and get timeline with display of level and sublevel.
    Timeline definition allows for leveling with JSON For now just use 
    internal representation
        
    TimeView --weeks=2 --level=2
    |         | m t w t f s s | m t w t f s s |
    | Pursuit | game --->dba---->high-------> |
    | Sublime | edit-->wasd-------END         |
    | Song    | rhythm---------->practice-----|

    -- speculating that gurgeh is chosen
    TimeView --months=4 --level=1
    |         |   oct   |   nov   |   dec   |
    | World   | pursuit-->gurgeh------------|
    | World   | Sublime                     |
    | Self    | Song1-->Song2---->Song3-----|

    So structure must  allow for multiple lines for each level.
    For myself, I'll lock the top level at  World/Self to fit with the 
    concept of `context.hs`

    TimeView must be a list structure that holds data and maybe sub-timeviews

-}
import qualified Data.Map as M

-- | types so they can like change and stuff
type TimeName = String
type TimeLen  = Int

type TimeView = [(M.Map TimeName TimeLine)] 
data TimeLine = TimeLine { tLen  :: TimeLen
                         , tSub  :: TimeView
                         }
                         deriving Show
-- | test data
tFromList x =  [M.fromList x]
timeEmpty =  [M.empty]
test_line = tFromList [("world", (TimeLine 10 pursuit))
                      ] ++ tFromList [("self" , (TimeLine 12 song))]

pursuit = tFromList [("game", (TimeLine 2 gurgeh))
                    ,("dba",  (TimeLine 5 timeEmpty))
                    ,("assurance", (TimeLine 23 timeEmpty))
                    ] ++
                    tFromList [("text", (TimeLine 7 timeEmpty))
                              ,("wasd", (TimeLine 4 timeEmpty))
                              ]
gurgeh = tFromList [("haskell road", (TimeLine 44 timeEmpty))
                   ,("Xmonad", (TimeLine 5 timeEmpty))
                   ]

song = tFromList [("song1", (TimeLine 7 timeEmpty))
                 ,("song2", (TimeLine 13 timeEmpty))
                 ]

getLength :: TimeView -> TimeLen
getLength tvs = foldl max 0 $ map lenDepth tvs
    where
         lenDepth tv =  M.fold foo 0 tv 
         foo t a  = (getLength (tSub t)) + (tLen t) + a 
         

getTimeLine :: TimeView -> [String]
getTimeLine tvs = map pLine tvs
    where pLine m = M.foldWithKey toS "" m
          toS k t a = a ++ (take ((tLen t) + (getLength $ tSub t)) $ k ++ (repeat '-')) ++ ">" 

timeToTable :: TimeView -> [((TimeName, TimeLen), [(TimeName, TimeLen)])]
-- | world |--->game----->dba----->assurance
-- | world |--->text--->wasd------>
-- | self  |------>song1--->song2------->
-- represented like 
-- [(world, 3), [(game, 10), (dba, 23), (assurance, 23)]
-- ,(world, 3), [(text, 8), (wasd, 12)]
-- ,(self, 5), [(song1, 12), (song2, 23)]
-- ]
          
timeToTable tvs = foldr f [] tvs
    where f tv a     = M.foldWithKey g [] tv ++ a
          g k tl b   = b ++ zipWith h (repeat (k, tLen tl)) (tSub tl)
          h t tv     = (t, M.foldWithKey j [] tv)
          j n tl' c  = c ++ [(n, ((tLen tl') + (getLength $ tSub tl')))]


main = do
    putStrLn "Starting"

