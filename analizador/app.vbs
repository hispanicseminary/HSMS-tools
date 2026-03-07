Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c app.bat"
oShell.Run strArgs, 0, false