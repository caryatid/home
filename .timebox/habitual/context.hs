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
-- | sense
-- | TODO | -----------------------
--  sense is a lens, i think.     I don't know what lenses are yet :)
--  but sense is a way of looking into a complex [ record syntax ] objects.
--  Then returning a part of that object. Very analogous to record syntax, but
--  perhaps with the ability to do something besides just retrieve data. For example, 
--  modify the complex object, or the returned data?
--  The point being that a sense is a transformation of WorldState to a specific
--  [ likely a class ] type for that particular sense. 
--  So human hearing is a transformation of WorldState to Sound by accessor 
--  style `getting` the air vibration frequency at your location.


{-
     | Notes
     +------
     perform :: WorldState a b c -> WorldState a b c
     Mind performs once a quanta.
     perform needs categories of sub actions like:
          modifyMind -- as in, to study :: World affects Mind
             learn:
              - goal = increased knowledge
              - unit = destructed World parameters
                    -- | concept is (modify self)  -> self
                    -- |            (modify world) -> self
                     practice: 
                      - goal = metric -- shortest distance etc
                      - unit = action
                     experiment:
                      - goal = new knowledge
                      - unit = World
             invent:
              - goal = new ideas
              - unit = current knowledge
                     planning:
                     analyzing: -- discovering the gaps where inventions fit 
          modifyWorld -- as in, to create :: Mind affects World
             create:
              - goal = idea
              - unit = environment
                    -- | concept is (modify self)  -> world
                    -- |            (modify world) -> world
                     move:    
                     build:
             separate:
              - goal = parts of objects
              - unit = objects
                     invetigate: -- make self different to view something
                                 -- somewhat analagous to glasses
                     disassemble:
                                 -- actually break something apart
                     
-}
     

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


