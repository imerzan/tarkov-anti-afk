;;; Can run from launcher, will start once game is running if you go AFK during Queue
;;; Will click the Character button to open your inventory (May need a backpack/rig on)
;;; Will then click an item in the first inventory slot (top-left), and move it one square to the right.
;;; On the next loop it will move the item bak to the first slot. Rinse repeat.
;;; Coordinates set for 1080P resolution
;;; By LoneSurvivor
#include <Misc.au3>
_Singleton ( "7UZnCR6mep-tKCsqVLDil", 0 ) ;; Allow only one instance to run
AutoItSetOption ( "TrayAutoPause" , 0 ) ;; Prevent Tray Auto-Pause
HotKeySet ( "{F11}", "Toggle" ) ;; Use whichever Hotkey you want
Global $Enabled = False ;; Disabled at start
Global $InFirstSlot = True; ;; Start with inventory slot 1

Global $charButton[2] ;; Coordinates of Character Button
$charButton[0] = 960 ;; x
$charButton[1] = 730 ;; y
Global $invTile1[2] ;; Coordinates of inventory tile 1
$invTile1[0] = 1299 ;; x
$invTile1[1] = 107 ;; y
Global $invTile2[2] ;; Coordinates of inventory tile 2
$invTile2[0] = 1363 ;; x
$invTile2[1] = 112 ;; y

HotKeySet ( "{F11}", "Toggle" )
Exit ( main() )

Global

Func main()
   While 1
	  While $Enabled And WinActive("EscapeFromTarkov") <> 0
		 ;; Click character button
		 Local $charClickDelay = Random(10, 50, 1)
		 MouseClick("LEFT", $charButton[0], $charButton[1], $charClickDelay)

		 ;; Wait for inventory
		 Local $waitDelay = Random(5000, 7000)
		 Sleep ($waitDelay)

		 If $InFirstSlot Then
			;; Click first inventory slot then drag to second
			Local $clickDragDelay = Random(10, 50, 1)
			MouseClickDrag ( "LEFT", $invTile1[0], $invTile1[1], $invTile2[0], $invTile2[1], $clickDragDelay)
		 Else
			;; Click second inventory slot then drag to first
			Local $clickDragDelay = Random(10, 50, 1)
			MouseClickDrag ( "LEFT", $invTile2[0], $invTile2[1], $invTile1[0], $invTile1[1], $clickDragDelay)
		 EndIf

		 ;; Wait for next loop
		 Local $sleepDelay = Random(60000, 90000, 1) ;; 60-90 sec between runs
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