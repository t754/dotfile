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
import XMonad.Actions.UpdatePointer
import XMonad.Actions.CopyWindow
myterm::String
-- myterm = "urxvt256c-ml"
myterm = "st -f \"Inconsolata:size=16\""


main::IO()
myManageHook::ManageHook

myManageHook = composeAll . concat $
    [ [className =? c --> doFloat  | c<-myfloat]
    , [className =? c --> doIgnore | c<-myignore]
    --- , className =? "Emacs" --> (ask >>= doF .  \w -> (\ws -> foldr ($) ws (copyToWss ["2","4"] w) ) . W.shift "3" ) :: ManageHook
    ]
    where myfloat = ["Vncviewer","Xfrun4","Xfce4-appfinder","MPlayer","Display.py"]
          myignore = ["Xfce4-notifyd","Wrapper-1.0"]


  --- where copyToWss ids win = map (copyWindow win) ids
-- myWorkspaces = ["1:work","2:web"] ++ map show [3..9]

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
     , className =? "Spotify"     --> doF (W.shift "8")
     , className =? "Steam"       --> viewShift "7"
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
myLogHook = do
  -- dynamicLogWithPP xmobarPP
  updatePointer (Relative 0.5 0.5)
  logHook xfceConfig

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
    , logHook = myLogHook
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
    , ("M-C-f"   , runOrRaise "firefox" (className =? "Firefox"))
    , ("M-C-S-d" , runOrRaise "evince" (className =? "Evince"))
    , ("M-C-S-w" , runOrRaise "spotify" (className =? "Spotify"))
    , ("M-C-S-h" , (raiseMaybe . unsafeSpawn) (myterm ++ " -t htopTerm -e htop") (title =? "htopTerm"))
    , ("M-d"     , (raiseMaybe . unsafeSpawn) "emacsclient -a emacs -c -n" (className =? "Emacs"))
    , ("M-S-t"   , (raiseMaybe. unsafeSpawn)
                   ("st -t dictTerm -f \"Inconsolata:size=16\" -e bash -c 'alce $(xsel -p) 2>&1 | less'")
                   (title =? "dictTerm"))
    , ("M-v"     , windows copyToAll)
    , ("M-S-v"   , killAllOtherCopies)
    , ("M-g"     , spawn "xdotool mousemove 0 0")
    ]
