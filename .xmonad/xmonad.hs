import XMonad
import XMonad.Util.EZConfig
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Config.Xfce
import XMonad.Layout.ResizableTile
-- import XMonad.Layout
-- import XMonad.Layout.Magnifier
-- import XMonad.Layout.Mosaic
-- import XMonad.Layout.Tabbed
-- import XMonad.Layout.Grid
-- import XMonad.Layout.IM
-- import XMonad.Layout.WindowNavigation
-- import XMonad.Layout.Gaps
-- import qualified XMonad.Layout.Fullscreen as FS
import Control.Monad (liftM2)          -- myManageHookShift
import qualified XMonad.StackSet as W  -- myManageHookShift
import qualified Data.Map        as M

-- import qualified Data.Map as M

import XMonad.Hooks.EwmhDesktops 
import XMonad.Hooks.SetWMName
-- import Data.Ratio ((%))
import XMonad.Layout.ToggleLayouts
-- import XMonad.Layout.Minimize
-- import qualified Data.Map as M
-- import XMonad.Actions.CopyWindow

-- import XMonad.Layout.SimplestFloat

myterm::String
-- myterm = "urxvt256c-ml"
myterm = "st -f \"Hack:size=16\""
-- myterm = "st -f \"RictyDiminished-Regular-Powerline:size=16\""
-- myterm = "urxvt256c-ml -e bash -c \"tmux -q has-session && exec tmux attach-session -d || exec tmux new-session \""
-- myterm = "urxvt256c-ml -e bash -c \"tmux  new-session \""
main::IO()
myManageHook::ManageHook

myManageHook = composeAll
    [ className =? "Vncviewer" --> doFloat
    -- , className =? "Gimp"      --> doFloat
    , className =? "Xfce4-notifyd" --> doIgnore
    , className =? "Xfrun4" --> doFloat
    , className =? "Xfce4-appfinder" --> doFloat
    , className =? "XClock" --> doFloat
    , className =? "MPlayer" --> doFloat
    -- , className =? "Xfce4-panel" --> doIgnore
    --- , className =? "Emacs" --> (ask >>= doF .  \w -> (\ws -> foldr ($) ws (copyToWss ["2","4"] w) ) . W.shift "3" ) :: ManageHook
    ] 
  --- where copyToWss ids win = map (copyWindow win) ids
myWorkspaces = ["1:work","2:web"] ++ map show [3..9]



myLayout = 
    toggleLayouts Full
    $ avoidStruts
    $ smartBorders
    $ Tall 1 (3/100) (1/2)
    ||| Mirror tall
    -- ||| simplestFloat
    ||| Full
    where
      -- skype = And (ClassName "Skype") (Role "")       
      tall = ResizableTall 1 (3/100) (7/10) []

    


myManageHookShift = composeAll
     [ className =? "Firefox" --> viewShift "2"
     , className =? "Skype" --> viewShift "5"
     , className =? "Chrome"   --> viewShift "3"
     , className =? "Keepassx"   --> viewShift "4"
     , className =? "Thunderbird"   --> viewShift "5"
     , className =? "VirtualBox"   --> viewShift "3"
     ]
  where viewShift = doF . liftM2 (.) W.view W.shift     

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]


main = xmonad $ xfceConfig
    { layoutHook         = myLayout
    , terminal           = myterm
    , focusedBorderColor = "Deep Pink"
    , modMask            = mod4Mask
    , borderWidth        = 3
    , manageHook         = myManageHook <+> myManageHookShift <+> manageHook xfceConfig
    , handleEventHook    = ewmhDesktopsEventHook <+> fullscreenEventHook
    , startupHook        = startupHook xfceConfig 
                         >> setWMName "LG3D" -- Java app focus fix                       
    -- , startupHook        = startupHook conf
    
    , mouseBindings      = myMouseBindings
    , logHook    = ewmhDesktopsLogHook                       
     }
    `additionalKeysP`
    [ ("M-S-r"   , restart "xmonad" True)
     ,("M-q"     , spawn "setxkbmap && xmodmap ~/.xmodmap")
    , ("M-S-q"   , spawn "xfce4-session-logout")
    , ("M-p"     , spawn "xfce4-appfinder")
    , ("M-S-f"   , spawn "pidof firefox || firefox")
    , ("M-S-e"   , spawn "emacsclient -c -n")  
    , ("M-f"     , sendMessage  ToggleLayout)
    , ("M-b"     , sendMessage   ToggleStruts)
    , ("M-S-h"   , sendMessage MirrorShrink)
    , ("M-S-l"   , sendMessage MirrorExpand)
    , ("M-S-z"   , spawn "xscreensaver-command -lock")
    , ("M-S-z"   , spawn "xscreensaver-command -lock")
    -- , ("M-S-t"   , spawn "xclock -chime -update 1 -geometry $(xdpyinfo | grep -B1 resolution | gawk -v SS=400 'BEGIN{FS=\"[ x]+\"} (NR==1){print SS\"x\"SS\"+\"$3/2-(SS/2)\"+\"$4/2-(SS/2)}')")
    , ("M-S-t" , spawn "xclock -chime -update 1")
    , ("M-g"     , spawn "xdotool mousemove 0 0")
    ]
 
