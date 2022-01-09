;;; Can run from launcher, will start once game is running if you go AFK during Queue
;;; Will click the Hideout Button and hit Enter to go first person
;;; Will move you around forwards/backwards in your hideout
;;; Hideout Coordinates set for 1080P resolution
;;; Randomization employed to appear as humanlike as possible.
;;; By LoneSurvivor
#include <Misc.au3>
_Singleton ( "hAXmL6vvhCesOuz2kr8jRaaqhzOKD9Dn-" & @UserName, 0 ) ;; Allow only one instance to run
AutoItSetOption ( "TrayAutoPause" , 0 ) ;; Prevent Tray Auto-Pause

Global $Enabled = False ;; Disabled at start
Global $Forward = True ;; Start with moving forward
Global $HideoutButtonMin[2] ;; Minimum Coordinates of Hideout Button
$HideoutButtonMin[0] = 882 ;; x
$HideoutButtonMin[1] = 851 ;; y
Global $HideoutButtonMax[2] ;; Maximum Coordinates of Hideout Button
$HideoutButtonMax[0] = 1031 ;; x
$HideoutButtonMax[1] = 885 ;; y

HotKeySet ( "{F11}", "Toggle" ) ;; Use whichever Hotkey you want
Exit ( main() ) ;; Startup

Func main()
   While 1
	  While $Enabled And WinActive("EscapeFromTarkov") <> 0
		 ;; Click hideout button
		 Local $hideoutClickDelay = Random(10, 50, 1)
		 Local $hideoutClickPos[2] ;; Randomize click location within a bounds
		 $hideoutClickPos[0] = Random($HideoutButtonMin[0], $HideoutButtonMax[0], 1)
		 $hideoutClickPos[1] = Random($HideoutButtonMin[1], $HideoutButtonMax[1], 1)
		 MouseClick("LEFT", $hideoutClickPos[0], $hideoutClickPos[1], $hideoutClickDelay)

		 ;; Wait for hideout
		 Local $waitDelay = Random(2000, 4500)
		 Sleep ($waitDelay)
		 ;; Press Enter to go first person
		 Local $enterDelay = Random(75, 150)
		 Opt("SendKeyDownDelay", $enterDelay)
		 Send("{ENTER DOWN}")
		 Send("{ENTER UP}")

		 ;; Set random delay
		 Local $movementDuration = Random(2000, 4000, 1)
		 Opt("SendKeyDownDelay", $movementDuration)

		 If $Forward Then
			;; Move forward a bit
			Send("{W DOWN}")
			Send ("{W UP}")
		 Else
			;; Move backwards a bit
			Send("{S DOWN}")
			Send ("{S UP}")
		 EndIf

		 ;; Prepare for next loop
		 $Forward = Not $Forward ;; Flip movement direction for next loop
		 Local $sleepDelay = Random(60000, 90000, 1) ;; 60-90 sec between movement
		 Sleep ($sleepDelay)
	  WEnd
	  Sleep(10) ;; CPU Idle
   WEnd
   Return 0
EndFunc


Func Toggle() ;; Toggles script on/off
   $Enabled = Not $Enabled
   If $Enabled Then
	  DllCall("Kernel32.dll", "UINT", "SetThreadExecutionState", "UINT", 0x00000001 Or 0x80000000) ;; Prevent Windows Sleep
	  Beep(750, 250) ;; Higher pitched beep for enabled
   Else
	  DllCall("Kernel32.dll", "UINT", "SetThreadExecutionState", "UINT", 0x80000000) ;; Allow Windows Sleep
	  Beep(150, 250) ;; Lower pitched beep for disabled
   EndIf
EndFunc