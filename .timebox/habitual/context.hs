import Control.Monad.State
-- ----------------------------------[ Outside Context ]---{{{
--  first make the machine behave then make it do as you 
--  want.

--  behave, as in watching something's behavior.

-- --------------------------------------[ Mind ]---{{{

-- Mind has a context. Something outside the world
-- that causes it to not always generate the same output
-- from the same input. Essentially external state.
-- Mind is a function. Mind is also part of  the WorldState
-- . At every quanta Mind will transform the current
-- WorldState to a new WorldState -- possible changing
-- Mind context as well.  This suggests that the context
-- of the Mind may be some analog to taste. Maybe.
--
-- So what affects WorldState, what affects Mind, does
-- anything affect both?
--
-- -- WorldState
-- - - build
-- -- Mind
-- - - storage
-- -- both
-- - - practice
-- - - experiment
-- -----------------------------[ skills ]---{{{

-- Mind has collections of functions for handling input/output.
-- These are essentially skills. They are likely each continuations
-- so that they can be modified.
-- -- something like:
-- -  - storage
-- -     - literature -- reads and modifies knowledge
--                       may add taste
-- -     - conceptual -- reads/does and modifies knowledge. 
--                       may add skill
-- -     - spatial    -- relational storage of positions. 
--                       may add point of interest.
-- |--------------- |
-- |  TODO | skills |
-- ----------------------------------[ . ]---}}}
-- 
-- -----------------------------[ tastes ]---{{{

-- Mind has collections of functions for deciding what to 
-- examine in the world. These, tastes, may also be continuations. 
-- either way I think they should be similar in context to 
-- skills and motions ( below ).
-- -- something like:
-- -  - outdoors -- tends towards outdoor investigations.
--                  can have sub-taste, like forests. 
--                  likely this would be the continuation bit.
-- -  - music    -- tends towards music
-- -  - aliens   -- *imagination* 
--
-- tastes are nearly slaves to the world they are
-- in. When free, imagination lives. Tastes are
-- generally features of the world. They can
-- be for something not of the world. These 
-- rare tasets can create WorldStates 
-- unlike the Mind.
--

-- |--------------- |
-- |  TODO | tastes |
-- ----------------------------------[ . ]---}}}

data Mind a b c = Mind { context :: a
                       , object :: b
                       , memory :: c
                       }
          

-- |------------- |
-- |  TODO | Mind |
-- ------[ 28c544c2-1a85-49bc-a4b5-467ec39885e6 ]---}}}
-- -------------------------------------[ world ]---{{{
--
data WorldState  a b c = WorldState { world :: World a b c 
                             , mind :: Mind a b c 
                             }

data Actions a b c = Actions { aMind :: a
                             , nObjects :: b
                             , perform :: WorldState a b c -> WorldState a b c
                             }

data World a b c = World { objects :: a 
                         , actions :: b
                         , minds :: c
                         }

-- |-------------- |
-- |  TODO | world |
-- ------[ db682909-bdfb-4338-81e3-ab994dff0bd3 ]---}}}

--  | Notes
--  +------
--  perform :: WorldState a b c -> WorldState a b c
--   Mind performs once a quanta.
--   perform needs categories of sub actions like:
--      modifyMind -- as in, to study :: World affects Mind
--         practice: 
--          - goal = metric -- shortest distance etc
--          - unit = action
--         learn:
--          - goal = increased knowledge
--          - unit = destructed World parameters
--         experiment:
--          - goal = new knowledge
--          - unit = World
--      modifyWorld -- as in, to create :: Mind affects World
--         create:
--          - goal = idea
--          - unit = World
--         communicate:
--          - goal = gain/impart knowledge
--          - unit = mind knowledge, minds
--         separate:
--          - goal = parts of objects
--          - unit = World item
-- 

-- | Maintenance cycles
-- +-------------------
--   - living area
--   - eating area
--   - working area
--   - self
--  Idea:
--      morning : self
--        first the body then the mind
--      midday  : cycle [working,living]
--      evening : eating

-- |------------------------ |
-- |  TODO | Outside Context |
-- -------------[ 3942e75c-cda0-41f7-b36e-6f623089d739 ]---}}}
