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

    TimeView is a list like structure of concurrent TimeLines
    [TimeLine] is a list of sequential actions
-}

type TDuration =  Int 
type TTitle = String

data TimeLine = TimeLine { tLen :: TDuration
                         , tNam :: TTitle
                         , subT :: Maybe TimeView
                         }
                         deriving(Show)

-- | should change [TimeLine] to be 'a' so changes are possible
data TimeView = TimeV [[TimeLine]]
                    deriving(Show)
test_tv = TimeV [[pursuit], [sublime], [song]]

pursuit = (TimeLine 10 "pursuit" (Just subPur))
sublime = (TimeLine 5 "sublime" (Just subSub))
song = (TimeLine 30 "song" (Just subSel))

subPur =  TimeV [[ (TimeLine 10 "game" (Just gurgeh))
                 , (TimeLine 20 "dba"  Nothing)
                 , (TimeLine 30 "high assurance" Nothing)
                 ]
                ,[ (TimeLine 23 "test" Nothing)
                 , (TimeLine 32 "test2" Nothing)
                 ]
                ]

subSub =  TimeV [[ (TimeLine 23 "edit" Nothing)
                , (TimeLine 13 "wasd" Nothing)
                ]]

subSel =  TimeV [[ (TimeLine 15 "song1" Nothing)
                , (TimeLine 23 "song2" Nothing)
                , (TimeLine 33 "song3" Nothing)
                ]]

gurgeh = TimeV [[ (TimeLine 10 "haskell book" Nothing)
                , (TimeLine 23 "XMonad" (Just foo))
                , (TimeLine 27 "Typeclassopedia" Nothing)
                ]]

foo = TimeV [[ (TimeLine 33 "grue" Nothing)]]

pTimeLine :: String -> Int -> String
pTimeLine n l
          | (length n) > l = take l n
          | otherwise = let dashes = l - (length n)
                            in n ++ (replicate dashes '-')

disTLine :: [TimeLine] -> String
disTLine tls = foldr (\x y -> (pTimeLine (tNam x) (getDuration x)) ++ ">" ++ y) [] tls


test :: [[TimeLine]] -> [TDuration]
test xs = map (\tls -> foldr (+) 0 $ map getDuration tls) xs

getDuration :: TimeLine -> TDuration
getDuration (TimeLine t n (Nothing)) = t
getDuration (TimeLine t n (Just (TimeV tls))) = let maxSub = foldr max 0 $ test tls
                                                    in t + maxSub  

timeToList :: TimeLine -> String
timeToList (TimeLine t n (Nothing)) = pTimeLine n t
timeToList (TimeLine t n (Just (TimeV tls))) = (pTimeLine n t) ++ ">" ++ (unlines $ (map disTLine tls))
main = do
    putStrLn "Starting"

