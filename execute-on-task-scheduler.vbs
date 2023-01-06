set fso = CreateObject("Scripting.FileSystemObject")
command = "powershell.exe -NoLogo -Command " + fso.GetParentFolderName(Wscript.ScriptFullName) + "\scoop-update-notifier.ps1"

set shell = CreateObject("WScript.Shell")
shell.Run command, 0
