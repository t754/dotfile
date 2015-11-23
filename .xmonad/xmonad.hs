import XMonad
import XMonad.Util.EZConfig
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Config.Xfce
import XMonad.Layout.ResizableTile
import Control.Monad (liftM2)          -- myManageHookShift
import qualified XMonad.StackSet as W  -- myManageHookShift
import qualified Data.Map        as M
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Layout.ToggleLayouts
import XMonad.Hooks.DynamicLog
import XMonad.Actions.WindowGo
import XMonad.Util.Run

myterm::String
-- myterm = "urxvt256c-ml"
myterm = "st -f \"Inconsolata:size=16\""


main::IO()
myManageHook::ManageHook

myManageHook = composeAll
    [ className =? "Vncviewer" --> doFloat
    , className =? "Xfce4-notifyd" --> doIgnore
    , className =? "Xfrun4" --> doFloat
    , className =? "Xfce4-appfinder" --> doFloat
    , className =? "XClock" --> doFloat
    , className =? "MPlayer" --> doFloat
    , className =? "ij-ImageJ" --> doFloat
    , className =? "fiji-Main" --> doFloat
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
    ||| Full
    where
      -- skype = And (ClassName "Skype") (Role "")
      tall = ResizableTall 1 (3/100) (7/10) []

myManageHookShift = composeAll
     [ className =? "Firefox"     --> viewShift "2"
     , className =? "Skype"       --> viewShift "5"
     , className =? "Chrome"      --> viewShift "3"
     , className =? "Keepassx"    --> viewShift "4"
     , className =? "Thunderbird" --> viewShift "5"
     , className =? "VirtualBox"  --> viewShift "3"
     , className =? "Spotify"     --> viewShift "7"
     ]
  where viewShift = doF . liftM2 (.) W.view W.shift

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [((modMask, button1),(\w -> focus w >> mouseMoveWindow w))
  ,((modMask, button2),(\w -> focus w >> windows W.swapMaster))
  ,((modMask, button3),(\w -> focus w >> mouseResizeWindow w))
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
    , mouseBindings      = myMouseBindings
     }
    `additionalKeysP`
    [ ("M-C-r"   , restart "xmonad" True)
    , ("M-C-q"   , spawn "setxkbmap && xmodmap ~/.xmodmap && xdotool mousemove 0 0")
    , ("M-q"     , spawn "xdotool mousemove 0 0")
    , ("M-S-q"   , spawn "xfce4-session-logout")
    , ("M-p"     , spawn "xfce4-appfinder")
    , ("M-f"     , sendMessage  ToggleLayout)
    , ("M-b"     , sendMessage   ToggleStruts)
    , ("M-S-h"   , sendMessage MirrorShrink)
    , ("M-S-l"   , sendMessage MirrorExpand)
    , ("M-C-S-z" , spawn      "xscreensaver-command -lock")
    , ("M-C-S-f" , runOrRaise "firefox" (className =? "Firefox"))
    , ("M-C-S-d" , runOrRaise "evince" (className =? "Evince"))
    , ("M-C-S-s" , runOrRaise "spotify" (className =? "Spotify"))
    , ("M-C-S-h" , (raiseMaybe . unsafeSpawn) (myterm ++ " -t htopTerm -e htop") (title =? "htopTerm"))
    , ("M-C-S-e" , (raiseMaybe . unsafeSpawn) "emacsclient -a emacs -c -n" (className =? "Emacs"))
    , ("M-S-t"   , spawn "notify-send \"$(ruby ~/bin/toast-alc.rb 2>&1)\"")
    , ("M-g"     , spawn "xdotool mousemove 0 0")
    ]
-- , ("M-S-t"   , spawn "xclock -chime -update 1 -geometry $(xdpyinfo | grep -B1 resolution | gawk -v SS=400 'BEGIN{FS=\"[ x]+\"} (NR==1){print SS\"x\"SS\"+\"$3/2-(SS/2)\"+\"$4/2-(SS/2)}')")
