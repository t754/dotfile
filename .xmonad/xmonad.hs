import           Control.Monad (liftM2)
import           Data.Char
import qualified Data.Map as M
import           XMonad
import           XMonad.Actions.CopyWindow
import           XMonad.Actions.UpdatePointer
import           XMonad.Actions.WindowGo
import           XMonad.Config.Xfce
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.SetWMName
import           XMonad.Layout.NoBorders
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.ToggleLayouts
import qualified XMonad.StackSet as W
import           XMonad.Util.EZConfig
import           XMonad.Util.Run



myterm::String
myterm = "xfce4-terminal"



main::IO()

myManageHook::ManageHook
myManageHook = composeAll . concat $
    [ [className =? c --> doFloat  | c<-myfloat]
    , [className =? c --> doIgnore | c<-myignore]
    , [title     =? t --> doFloat  | t<-myfloatTitle]
    ]
    where myfloat = ["Vncviewer","Xfrun4","Xfce4-appfinder","MPlayer","Display.py"]
          myignore = ["Xfce4-notifyd","Wrapper-1.0","xfce4-panel"]
          myfloatTitle = (map ("Figure " ++) (map (\x -> [x]) (map (intToDigit) [1..9])))


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
     , className =? "Keepassx"    --> viewShift "9"
     , className =? "jetbrains-studio" --> viewShift "4"
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
  ]

myLogHook = do
  ewmhDesktopsLogHook
  updatePointer (0.5, 0.5) (0 , 0)
  -- dynamicLogWithPP xmobarPP
  -- logHook xfceConfig

main = xmonad $ ewmh xfceConfig
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
    , ("M-v"     , windows copyToAll)
    , ("M-S-v"   , killAllOtherCopies)
    , ("M-g"     , spawn "xdotool mousemove 0 0")
    ]
