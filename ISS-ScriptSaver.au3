;#AutoIt3Wrapper_Run_After="C:\Users\User\Documents\My QM\Plugins\Run_UPX_SIGN_LRG.exe" %out% -MODE=2
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_After=""%scitedir%\..\Extras\AutoUPX.exe" "%out%""

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         M. Schindlauer

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
$Titel = "ISS Script Saver"

$sVer = FileGetVersion("Winver.exe")
$nVer = StringLeft($sVer, StringInStr($sVer,".")-1)

if $CmdLine[0] < 1 Then
MsgBox(4096 + 16, $Titel , "Falscher Aufruf:" & Chr(13) & "Aufruf bitte nur mit Angabe des Scriptnamens!", 3)
Exit(3)
endif

;$issname =  $CmdLine[1]

$issname =  $CmdLineRaw  ;;Übergabe mit Leerzecihen jetzt auch ohne Anführungszeichen auch möglich!

$issname=StringReplace($issname, '"', '')

;msgbox(16,"", $CmdLine[0] & "" & $CmdLineRaw)
;$issname="PDFXCEditor-Stempel&Tools.iss" ;zum testen...

Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",2)
Opt("WinDetectHiddenText",1)

;MsgBox(16,"","Bin da...")

WinActivate($issname & " – Inno Setup Compiler")
if Not WinActive($issname & " – Inno Setup Compiler") Then
MsgBox(4096 + 16,$Titel,"Inno Setup Compiler konnte nicht aktiviert werden!" & chr(13) & _
					"Fenstername: " & chr(13) & $issname & " - Inno Setup Compiler...")
Exit(4)

EndIf


;Ermittle Sprache:
;Ermittle Sprache:
;könnte man auch über Registry Eintrag: HKEY_CURRENT_USER\Software\Jordan Russell\Inno Setup\Options Wert von Language ermitteln (3=GER)
;Dazu müsste man auch noch die aktuell laufende Inno Setup Instanz abfragen (z.B.: mit 
;Local $InnoVer=WinGetTitle($issname & " – Inno Setup Compiler")
;if StringInStr($InnoVer," - Inno Setup Compiler 7." ) Then...

Send ("!h")
Sleep(500)
Send ("ü") ;ü nuir bei Deutsch!
Send ("{RIGHT}") ;;verhindert den ungewollten Start eines Hilfemenü Eintrages wenn nicht Deutsch...

WinWait("About Inno Setup","",3)
if WinExists("About Inno Setup") then
	$Lang="GER"
WinClose("About Inno Setup")
Else
	$Lang="ENG"
EndIf

$erg=MsgBox(64 + 1, $Titel , "Aktuelles ISS Script:" & Chr(13) & $issname & Chr(13) & "wird jetzt zuerst automatisch gesichert!" & Chr(13) & Chr(13) & _
"Diese Meldung verschwindet auch von selbst...", 3)
;MsgBox(64, $Titel , $erg)
if $erg = 2 then Exit(2)

;PDFEditor-Stempel&Tools.iss – Inno Setup Compiler 6.7.1 – Non-commercial use only
WinActivate($issname & " – Inno Setup Compiler")

Sleep(1000)
if Not WinActive($issname & " – Inno Setup Compiler") Then
MsgBox(4096 + 16,$Titel,"Inno Setup Compiler konnte nicht aktiviert werden!" & chr(13) & _
					"Fenstername: " & chr(13) & $issname & " - Inno Setup Compiler...    (2)")
Exit(4)
EndIf

Local $iInt =0

SendKeepActive($issname & " - Inno Setup Compiler")

if $Lang="GER" Then
Send ("!d")
Sleep(500)
Send ("u")
else
Send ("!f")
Sleep(500)
Send ("a")
EndIf

if $Lang="GER" Then
WinWait("Speichern unter","", 3)
Else
WinWait("Save as","", 3)
EndIf

if Not WinExists("Speichern unter") Then
if Not WinExists("Save as") Then
MsgBox(16,$Titel,"Aktuelles ISS Script:" & Chr(13) & $issname & Chr(13) & "konnte nicht gesichert werden!")
Exit(4)
EndIf
EndIf

if WinExists("Speichern unter", $issname) then
SendKeepActive("Speichern unter", $issname)
EndIf
if WinExists("Save as", $issname) then
SendKeepActive("Save as", $issname)
EndIf

;MsgBox(0,$Titel,"Bin da...")
Send ("{Enter}")

;Bis Ver 6 "Speichern unter" dann "Speichern unter bestätigen"

if $nVer < 6 Then
$Savetxtde = "Speichern unter"
$Savetxten = "Save As"
Else
$Savetxtde = "Speichern unter bestätigen"
$Savetxten = "Confirm Save As"
EndIf


WinWaitActive($Savetxtde, "",3)
if WinActive($Savetxtde, "") Then
	SendKeepActive($Savetxtde, "")
	if WinActive($Savetxtde, "") Then
	send ("j")
	EndIf
	if WinActive($Savetxtde, "") Then
	send ("y")
	EndIf
Else
WinWaitActive($Savetxten, "",3)
if WinActive($Savetxten, "") Then
	SendKeepActive($Savetxten, "")
	if WinActive($Savetxten, "") Then
	send ("y")
	EndIf
	if WinActive($Savetxten, "") Then
	send ("j")
	EndIf
EndIf
EndIf


;Es wurden die msg Fenster auf SystemModal umgestellt damit sie im Vordergrund erscheinen
;Die erstellte EXE-Datei wird signiert - sonst Viruswarnung...
;Eine Spracherkennung wurrde eingefügt, da ab Inno Setup 7 auch deutsche Menüs möglich sind...
;Leerzeichen im übergebenen Scriptnamen werden jetzt auch akzeptiert...
