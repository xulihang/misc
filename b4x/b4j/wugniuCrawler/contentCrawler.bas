Type=StaticCode
Version=5.9
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private ccForm As Form
	Private Button1 As Button
	Private Label1 As Label
	Private ListView1 As ListView
	Private TextField1 As TextField
End Sub

Public Sub show
	If ccForm.IsInitialized=False Then
	    ccForm.Initialize("cc",300dip,500dip)
	    ccForm.RootPane.LoadLayout("cc") 'Load the layout file.
	    ccForm.Show
		ListView1.Items.AddAll(File.ReadList(File.DirAssets,"ci.txt"))
	End If
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	For Each item As String In ListView1.Items
		TextField1.Text=item
		Dim job As HttpJob
		job.Initialize("job",Me)
        Dim su As ApacheSU
		Dim list1 As List
		list1=su.SplitWithSeparator(item,"	")
		Dim url As String
		url="http://www.wugniu.com"&list1.Get(3)
		Log(url)
		job.Download(url)
		Wait For (job) JobDone (job As HttpJob)
		If job.Success Then
			Log(job.GetString)
            'saveContent
			Dim filename As String
			filename=list1.Get(0)&".html"
			filename=filename.Replace("\","")
			filename=filename.Replace("/","")
			File.WriteString(File.DirApp,filename,job.GetString)

		Else
			Dim textWriter As TextWriter
			textWriter.Initialize(File.OpenOutput(File.DirApp,"missed",True))
			textWriter.Write(item&CRLF)
			textWriter.Close
			Log(job.ErrorMessage)
		End If
		job.Release
	Next
End Sub