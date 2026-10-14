# ISS-ScriptSaver

Dieses Autoit-Tool ermöglicht die automatische Sicherung von Änderungen vor der Kompilierung eines Inno Setup Scripts: 
Dies ist besonders nützlich, wenn das Script itself in das Setup File mit hineinkopiert werden soll, um es später bei Bedarf wieder 1:1 (z.B.: mit InnoUnp...) herstellen zu können..

Neu ist die Spracherkennung auch für die deutsche Oberfläche des neuen Inno Setup 7 Editor!

Vorbereitung:
Die ISS-ScriptSaver.au3 Datei mit (einem natürlich vorher installiertem) Autoit3 kompilieren... Eine von mir erstellte und mit UPX komprimierte, und von mir selbstsignierte EXE Datei, ist auch im Anhang...
Ich verwende Autoit Freeware-Skriptsprache gerne mal wieder um schnell kleine praktische Tools zu erstellen...
Mein Programm "ISS-ScriptSaver.exe" in das Programmverzeichnis der jeweiligen Version des Inno Setup Kompiler
z.B.: in ein Unterverzeichnis "Plugins" stellen, Pfad später im ISS Script anpassen...

In den Scripten, die dieses Feature erhalten sollen, müssen im Kopf folgende Zeilen eingefügt werden:
Achtung: Es darf nur ein *.iss File im Source Verzeichnis enthalten sein - sonst SourceFileName fix angeben!
=erst mit der Zeile des NICHT mehr auskommentierten "#define SourceFileName..." beginnen oder Zeile: "#error "More than one script found""  auskommentieren...

#define ScriptFindHandle = FindFirst(SourcePath + "\*.iss", 0)
#if !ScriptFindHandle
  #error "No script found"
#endif
#define SourceFileName = FindGetFileName(ScriptFindHandle)
#if FindNext(ScriptFindHandle)
  #error "More than one script found"
#endif
#expr FindClose(ScriptFindHandle)

;#define SourceFileName = "ISS-Setup-Filename.iss" ;Achtung: Gross- u. Kleinschreibung beachten!!!
#define SourceBaseName = RemoveFileExt(SourceFileName)

;Folgende ISPP Anweisungen sind für die automatische Sicherung dieses Files und Kompilierung erforderlich:
#define Execerg Exec("Plugins\ISS-ScriptSaver.exe", """" + SourceFileName + """")
#if Execerg == 0
;nix	;ev. eine Erfolgsmeldung...
#else
#error "Ein Fehler ist beim Sichern dieses ISS Files aufgetreten!"
#endif
...


Im Abschnitt: [Setup] kann dann der EXE-Name des Setups mit OutputBaseFilename={#SourceBaseName} angegeben werden,
und das vorher automatisch gesicherte Original ISS-Setup-Scriptfile mit ins Setup aufgenommen werden, mit dem folgenden Eintrag unter [Files]:
[Files]
...
;Alle ISS Source Files:
;Source: "*.iss"; DestDir: "{tmp}";
;oder gezielt:
Source: "{#SourceFileName}"; DestDir: {tmp}
...

Ein eigener Startmenü-Deinstallationseintrag kann dann auch noch unter [Icons] erstellt werden, falls eine Programmgruppe angegeben oder ermittelt wurde:
[Icons]
...
Name: "{group}\{#SourceBaseName} Uninstall"; Filename: {uninstallexe};
...

Code:
siehe angefügte ISS-ScriptSaver.au3
