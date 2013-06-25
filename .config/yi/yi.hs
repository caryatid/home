import Yi

-- Preamble
import Yi.Prelude
import Prelude (take, length, repeat)
import Yi.Command
import Yi.Mode.Buffers
import Yi.Keymap.Vim(mkKeymap,defKeymap,ModeMap(..))

import Data.Time.Clock(getCurrentTime)
import System.Locale(defaultTimeLocale)
import Data.Time.Format(formatTime)

import Yi.UI.Vty (start)
-- import Yi.UI.Cocoa (start)
-- import Yi.UI.Pango (start)

-- Used in Theme declaration
import Data.Monoid(mappend)

myTheme = defaultTheme `override` \super _ -> super
  { modelineAttributes   = emptyAttributes { foreground = darkblue,
           background = blue}
  , tabBarAttributes     = emptyAttributes { foreground = white, background = darkred            }
  , baseAttributes       = emptyAttributes { foreground = cyan, background = black, bold=True }
  , commentStyle         = withFg blue `mappend` withBd False `mappend` withItlc True
--  , selectedStyle        = withFg black   `mappend` withBg green `mappend` withReverse True
  , selectedStyle        = withReverse True
  , errorStyle           = withBg red     `mappend` withFg white
  , operatorStyle        = withFg brown   `mappend` withBd False
  , hintStyle            = withBg brown   `mappend` withFg black
  , modelineFocusStyle  = withBg white  `mappend` withFg red
  , importStyle          = withFg blue
  , dataConstructorStyle = withFg blue
  , typeStyle            = withFg blue
  , keywordStyle         = withFg yellow
  , builtinStyle         = withFg brown
  , strongHintStyle      = withBg brown   `mappend` withUnderline True
  , stringStyle          = withFg brown   `mappend` withBd False
  , preprocessorStyle    = withFg blue
--  , constantStyle      = withFg cyan
--  , specialStyle      = withFg yellow
  }
defaultUIConfig = configUI defaultVimConfig

main :: IO ()
main = yi $ defaultVimConfig
  {
   -- Options:
   configUI = defaultUIConfig
     { 
       configTheme = myTheme,       
       configWindowFill = ' ' 
                          -- '~'    -- Typical for Vim
     }
  }

-- | BUCKET | ---------------------------------------
-- pipe IO shell
