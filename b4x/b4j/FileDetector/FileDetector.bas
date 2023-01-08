B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.9
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Private Sub checkIfFileExists As ResumableSub
	Dim sh As Shell
	sh.Initialize("sh","file",Null)
	sh.Run(-1)
	wait for sh_ProcessCompleted (Success As Boolean, ExitCode As Int, StdOut As String, StdErr As String)
	If Success = True Then
		Log("file exists")
		Return True
	End If
	Return False
End Sub

Public Sub detect(dir As String,filename As String) As ResumableSub
	wait for (checkIfFileExists) complete (fileExists As Boolean)
	Dim exe As String = "file"
	If fileExists = False Then
		exe = File.Combine(File.DirApp,File.Combine("File","file"))
	End If
	Log(exe)
	Dim sh As Shell
	sh.Initialize("sh",exe,Array(File.Combine(dir,filename)))
	sh.Run(-1)
	wait for sh_ProcessCompleted (Success As Boolean, ExitCode As Int, StdOut As String, StdErr As String)
	If Success Then
		Return StdOut
	End If
	Return ""
End Sub