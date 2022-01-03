;;; Can run from launcher, will start once game is running if you go AFK during Queue
;;; Will click the Hideout Button and hit Enter to go first person
;;; Will move you around forwards/backwards in your hideout
;;; Hideout Coordinates set for 1080P resolution
;;; By LoneSurvivor
#include <Misc.au3>
_Singleton ( "7UZnCR6mep-tKCsqVLDil", 0 ) ;; Allow only one instance to run
AutoItSetOption ( "TrayAutoPause" , 0 ) ;; Prevent Tray Auto-Pause
HotKeySet ( "{F11}", "Toggle" ) ;; Use whichever Hotkey you want
Global $Enabled = False ;; Disabled at start
Global $Forward = True ;; Start with moving forward
Global $hideoutButton[2] ;; Coordinates of Hideout Button
$hideoutButton[0] = 960 ;; x
$hideoutButton[1] = 871 ;; y

HotKeySet ( "{F11}", "Toggle" )
Exit ( main() )

Global

Func main()
   While 1
	  While $Enabled And WinActive("EscapeFromTarkov") <> 0
		 ;; Click hideout button
		 Local $hideoutClickDelay = Random(10, 50, 1)
		 MouseClick("LEFT", $hideoutButton[0], $hideoutButton[1], $hideoutClickDelay)

		 ;; Wait for hideout
		 Local $waitDelay = Random(5000, 7000)
		 Sleep ($waitDelay)
		 ;; Press Enter to go first person
		 Send("{ENTER}")

		 If $Forward Then
			;; Move forward a bit
			Local $keydownDelay = Random(2000, 4000, 1)
			Opt("SendKeyDownDelay", $keydownDelay)
			Send("{W DOWN}")
			Send ("{W UP}")
		 Else
			;; Move backwards a bit
			Local $keydownDelay = Random(2000, 4000, 1)
			Opt("SendKeyDownDelay", $keydownDelay)
			Send("{S DOWN}")
			Send ("{S UP}")
		 EndIf

		 Opt("SendKeyDownDelay", 5) ;; Reset delay (for enter key)
		 $Forward = Not $Forward ;; Flip variable for next run

		 ;; Wait for next loop
		 Local $sleepDelay = Random(60000, 90000, 1) ;; 60-90 sec between moving
		 Sleep ($sleepDelay)
	  WEnd
	  Sleep(10)
   WEnd
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