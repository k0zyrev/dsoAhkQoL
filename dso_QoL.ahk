#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#IfWinActive Drakensang Online | The free to play action MMORPG - DSO
#IfWinActive Drakensang Online

; this is basically default ahk setting, not necessary
;CoordMode, Mouse, Relative
; 0 - fast, 100 - slow, 2 - default
;SetDefaultMouseSpeed, 2
; -1 - no delay, 0 - smallest possible delay
SetMouseDelay, 150
SysGet, xWBThicc, 32
SysGet, yWBThicc, 33


;infullscreen mode those are automatically calculated as 0 (I assume)


;window border thickness required for coordinate calculations. For extra info read the file end
xOffset := xWBThicc 

;there's yWBThicc - border thickness, but also there's window header. I just eyballed its height as 22px tall. It works.
yOffset := yWBThicc + 22 

;top+bottom borders+height of the window header. Needed for correct calculations of the actual game's height and width
yExtraThicc := 2*yWBThicc + 22 

;ctrl+f
;fill in password
~^F::
	send yourpasswordhere
	sleep 100
	send {Enter}
return

;alt+s
;autogrind current page of gems
;hold ctrl to stop after grinding current gem stack
;hold alt to switch to the next inventory tab and continue grinding gems (to tab#3, #4, etc)
;we assume the first inventory tab is never used to store gems or jewels
!s::

	;numerical codes for thickness of window borders for the window 32-x, 33-y 
	SysGet, xWBThicc, 32
	SysGet, yWBThicc, 33

	xOffset := xWBThicc
	yOffset := yWBThicc + 22 
	yExtraThicc := 2*yWBThicc + 22 
		
	; X, Y, Width, Height, WinTitle, WinText
	WinGetPos, , , dsoWidth, dsoHeight, A
	WinGetTitle, title, A	
	
	dsoWidth  := dsoWidth - 2*xOffset
	dsoHeight := dsoHeight - yExtraThicc

	;size of an inventory cell
	invSize := Round(dsoHeight * 0.075)
	tabWidth := Round(dsoHeight * 0.042)
	
	tabX := Round(dsoHeight * 0.403) + xOffset
	tabY := Round(dsoHeight * 0.169) + yOffset
	
	invItX := dsoWidth - Round(dsoHeight * 0.539) + 3*xOffset
	invItY := Round(dsoHeight * 0.570) + yOffset
	
	maxX := Round(dsoHeight * 0.500) + xOffset
	maxY := Round(dsoHeight * 0.757) + yOffset
	
	craftX := Round(dsoHeight * 0.619) + xOffset
	craftY := Round(dsoHeight * 0.631) + yOffset
	
	invTabX :=	dsoWidth - Round(dsoHeight * 0.493) + 2*xOffset
	invTabY :=	Round(dsoHeight * 0.525) + yOffset
	
	wisdomX := dsoWidth / 2 - dsoHeight * 0.254 + xOffset
	wisdomY :=	dsoHeight * 0.174 + yOffset
	
	benchX := dsoWidth / 2 - dsoHeight * 0.058 + xOffset
	benchY :=	dsoHeight * 0.794 + yOffset

	Send {s down}{s up}
	Sleep 200
	Click, %wisdomX% %wisdomY% Left
	Sleep 100
		i := 0
		tabN := 1 ;enumeration starts with 0 - so we skip tab1 and assume we start on tab2
		itemY := invItY
		while (i<4) {
			itemX := invItX
			k := 0
			While (k<7) {
				;resetting the brnch might be useless tho
				; Click, %benchX% %benchY% Left
				if (k > 0 or i > 0) 
				{
					Send {s down}{s up}
					Sleep 100
				}
				Click, %benchX% %benchY% Left
				sleep 401		
				Click, %tabX% %tabY% Left
				sleep 501
				Click, %itemX% %itemY% Right
				sleep 521
				Click, %maxX% %maxY% Left
				sleep 554
				Click, %craftX% %craftY% Left
				sleep 200
				
				itemX := itemX + invSize
				k := k+1
				
				if (GetKeyState("Control", "P")) {
					return
				}
				
				if (GetKeyState("Alt", "P")) {
					invTX := invTabX + tabWidth * tabN
					Click, %invTX% %invTabY% Left
					sleep 100
					tabN := tabN + 1
					i := -1
					k := 7
					itemY := invItY - invSize
				}
				
				Send {Esc}
				sleep 550
				
			}
			itemY := itemY + invSize
			i := i+1
		}
;		MsgBox all good
	; }
return


;z
;fast mount
;cloak must be on first inv tab, row 2 column 3 (I think. You'll see)
;typing z in chat will result in mounting. Change hotkey if you often use wirds with Z
z::
	WinGetPos, , , dsoWidth, dsoHeight, A
	dsoWidth  := dsoWidth - 2*xOffset
	dsoHeight := dsoHeight - yExtraThicc
	BlockInput, MouseMove  
	MouseGetPos, mousepX, mousepY

	;hardcoded coordinates for the cloak in the inventory. Go to the bottom of the file for the instructions to 
	;change the coordinates of the cloak
	cloakX := dsoWidth - dsoHeight * 0.361 + xOffset
	cloakY := dsoHeight * 0.670 + yOffset
	
	closeInvX := dsoWidth - dsoHeight * 0.022 + xOffset
	closeInvY := dsoHeight * 0.097 + yOffset
	
	invTab1X :=	dsoWidth - Round(dsoHeight * 0.53) + 2*xOffset
	invTab1Y :=	Round(dsoHeight * 0.525) + yOffset
	
	Click, %closeInvX% %closeInvY% Left
	
	Send {i}
	Sleep 25
	Click, %invTab1X% %invTab1Y% Left
	Sleep 75
	Click, %cloakX% %cloakY% Left 2
	Sleep 75
	Send {a}
	Sleep 100
	Click, %cloakX% %cloakY% Left 2
	Sleep 50
	Send {i}
	
	Click, %mousepX% %mousepY% 0
	BlockInput, MouseMoveOff  	
return


;ctrl+s
;autochat
^s::
	sleep 250
	Send {Enter down}{Enter up}
	Sleep, 50
	Send /a thabo +10 1/5{enter}
	Sleep, 50
	Send {Enter up}
return


;ctrl+z
;john sunlair quest sargon kubes autofinish
^z::
	;numerical codes for thickness of window borders for the window 32-x, 33-y 
	SysGet, xWBThicc, 32
	SysGet, yWBThicc, 33

	xOffset := xWBThicc
	yOffset := yWBThicc + 22
	yExtraThicc := 2*yWBThicc + 22 
		
	; X, Y, Width, Height, WinTitle, WinText
	WinGetPos, , , dsoWidth, dsoHeight, A
	WinGetTitle, title, A	
	
	dsoWidth  := dsoWidth - 2*xOffset
	dsoHeight := dsoHeight - yExtraThicc
	
	questX := Round(dsoHeight * 0.4) + xOffset
	questY := Round(dsoHeight * 0.12) + yOffset
	
	confirmX := Round(dsoHeight * 0.505) + xOffset
	confirmY := Round(dsoHeight * 0.28) + yOffset
	
	; ToolTip, Click the questgiver
	; KeyWait, LButton, D
	; MouseGetPos, questNPCX, questNPCY	
	; ToolTip
	
	; Sleep, 200
	
	; While GetKeyState("LCtrl", "P"){
		Click, %questX% %questY% Left
		Sleep, 300
		
		Click, %confirmX% %confirmY% Left
		Sleep, 300
		
		Click, %questX% %questY% Left
		Sleep, 300
		
		Click, %confirmX% %confirmY% Left
		Sleep, 300
		
		Click, %questX% %questY% Left
		Sleep, 300
		
		Click, %confirmX% %confirmY% Left
		Sleep, 300
		
		Click, %questX% %questY% Left
		Sleep, 300
		
		Click, %confirmX% %confirmY% Left
		Sleep, 300
		
		Click, %confirmX% %confirmY% Left
		Sleep, 500
		
		Click, %confirmX% %confirmY% Left
		Sleep, 500
					
		Click, %confirmX% %confirmY% Left
		Sleep, 500
		
		Click, %confirmX% %confirmY% Left
		Sleep, 500
	; }	
return


;ctrl+`
;switch between build tabs 1<>2
~^`::
	WinGetPos, , , dsoWidth, dsoHeight, A
	dsoWidth  := dsoWidth - 2*xOffset
	dsoHeight := dsoHeight - yExtraThicc
BlockInput, MouseMove  
MouseGetPos, mousepX, mousepY
If skillset := Not skillset
{	
	send {s down}{s up}
	sleep 150
	crdX := dsoHeight * 0.319 + dsoWidth / 2 + dsoHeight * 0.048 * 1 + xOffset
	crdY :=	dsoHeight * 0.237 + yOffset
	Click, %crdX% %crdY%
	sleep 50
	send {s down}{s up}
	sleep 50
	send {Numpad1  down}{Numpad1  up}
	sleep 50
} Else {
	send {s down}{s up}
	sleep 150
	crdX := dsoHeight * 0.319 + dsoWidth / 2 + xOffset
	crdY :=	dsoHeight * 0.237 + yOffset
	Click, %crdX% %crdY%
	sleep 50
	send {s down}{s up}
	sleep 50
	send {Numpad2  down}{Numpad2  up}
	sleep 50
}
Click, %mousepX% %mousepY% 0
BlockInput, MouseMoveOff  
return


;`
;switch panel
;panels must be assigned to Num1 and Num2
~`::
If whatever := Not whatever
{	
	send {Numpad1  down}{Numpad1  up}
	sleep 50
} Else {
	send {Numpad2  down}{Numpad2  up}
	sleep 50
}
return


;MB4
;autoclick RMB
; ~$CapsLock::
~$XButton2::
    ; While GetKeyState("CapsLock", "P"){
    While GetKeyState("XButton2", "P"){
		;Send {LButton  down}{LButton  Up}
		Click, Right
		; Click, Left
        Sleep 100
    }
return

;alt+CAPS
;autoclick LMB
~$!CapsLock::
    While GetKeyState("CapsLock", "P"){
		;Send {LButton  down}{LButton  Up}
		; Click, Right
		Click, Left
        Sleep 150
    }
return


;ALT+g
;GO->port->cata bloodchest
!g::
	SysGet, xWBThicc, 32
	SysGet, yWBThicc, 33
	
	xOffset := xWBThicc
	yOffset := yWBThicc + 22
	yExtraThicc := 2*yWBThicc + 22 
		
	; X, Y, Width, Height, WinTitle, WinText
	WinGetPos, , , dsoWidth, dsoHeight, A
	WinGetTitle, title, A	
	;numerical codes for thickness of window borders for the window 32-x, 33-y 
	
	
	;this section calculates coordinates for the mouse clicks
	dsoWidth  := dsoWidth - 2*xOffset
	dsoHeight := dsoHeight - yExtraThicc
	
	tabWidth := Round(dsoHeight * 0.042)
	
	tab1X := dsoWidth - Round(dsoHeight * 0.493) + 2*xOffset - tabWidth
	tab1Y := Round(dsoHeight * 0.525) + yOffset
	
	inv1X := dsoWidth - Round(dsoHeight * 0.539) + 3*xOffset
	inv1Y := Round(dsoHeight * 0.570) + yOffset
	
	
	;assuming you're already in catacombs, so you only need to click on cata itself, without chosing the region
	cataX := dsoWidth / 2 - dsoHeight * 0.187 + xOffset
	cataY := dsoHeight * 0.319 + yOffset
	
	confirmX := dsoWidth / 2 + dsoHeight * 0.364 + xOffset
	confirmY := dsoHeight * 0.775 + yOffset
	
	payX := dsoWidth / 2 + xOffset
	payY := dsoHeight * 0.542 + yOffset
	
	
	;exetucing the clicking
	sleep 250
	Send {Enter down}{Enter up}
	Sleep, 50
	Send /p go{enter}
	Sleep, 50
	; Click, %chatX% %chatY% Left
	Send {i down}{i up}
	Sleep, 50
	Click, %tab1X% %tab1Y% Left
	Sleep, 50
	Click, %inv1X% %inv1Y% Right
	Sleep, 50
	Click, %cataX% %cataY% Left
	Sleep, 400
	Click, %confirmX% %confirmY% Left
	Sleep, 400
	Click, %payX% %payY% Left
return


;ctrl+r
;RELOAD SCRIPT
^r:: ; press control+r to reload
    Reload
return



;Since the game has adaptive interface, the relation between height and width of the interface elements stays the same. 
;you need to take a screenshot of the element you want to click on, then take resolution of the screenshot and find 
;the height (you'll need it for later). Then what you need to do is to find the _length in pixels
;from point of reference to the interface element you need. 
;If the element
	;snaps to the left side of the screen
		;_length is just X coord (of the element)
	;to the right side
		;_length is ScreenshotWidth minus X coord
	;automatically centers
		;_length is ScreenshotWidth/2 munis X coord (you can get negative number depending on which side from the center 
		;the element is, disregard the minus sign)
		
;then you need to divide the resulting _length by ScreenshotHeight - you will get the ratio which will always
;point to the X coord of the element you want to click on
;_ratio = _length/ScreenshotHeight
;so in order to get the X coord for element, you need to do it in reverse order:
;for interface elements
	;which snap to the left of the screen
		;X = dsoHeight * _ratio +xOffset
			;the most simple case. Not much useful interface buttons are there.
			;xOffset is required to compensate for the window border width, which Autohotkey always includes when it gives
			;you width of the whole window
	;which snap to the right side of the screen
		;X = dsoWidth -dsoHeight * _ratio + 2*xOffset
			;the most common case. 2*xOffset is required to use because we use right side as the point of reference and 
			;it now includes width of both left and right border of the window
	;which snap to the middle of the screen
		;X = dsoWidth / 2 - dsoHeight * _ratio + xOffset
		;we SUBTRACT dsoHeight * _ratio in case the element is to the left of the center of the screen
		;and we ADD dsoHeight * _ratio in case the element is to the right of the center of the screen.
;for the Y coord we use the same logic with one caveat - point of reference is always to, so in order to get the _ratioY
;all you need to do is to divide Y coord of the item by ScreenshotHeight. The rest is same.
