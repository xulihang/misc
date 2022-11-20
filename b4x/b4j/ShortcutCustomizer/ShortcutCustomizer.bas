B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.9
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private frm As Form
	Private shortcuts As Map
	Private ShortcutsListView As ListView
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(mb As MenuBar)
	frm.Initialize("frm",500,300)
	frm.RootPane.LoadLayout("ShortcutCustomizer")	
	shortcuts.Initialize
	readShortcutsAsMap(mb)
	loadShortCutsToListView
End Sub

Public Sub showAndWait As Map
	frm.ShowAndWait
	Return shortcuts
End Sub

Private Sub loadShortCutsToListView
	For Each key As String In shortcuts.Keys
		Dim p As Pane
		p.Initialize("")
		p.LoadLayout("ShortcutItem")
		p.SetSize(ShortcutsListView.Width,50)
		Dim lbl As Label = p.GetNode(0)
		Dim tf As TextField = p.GetNode(1)
		lbl.Text = key
		tf.Text = shortcuts.Get(key)
		ShortcutsListView.Items.Add(p)
	Next
End Sub

Private Sub readShortcutsAsMap(mb As MenuBar)
	For Each m As Menu In mb.Menus
		readShortcutsFromMenu(m)
	Next
End Sub

Private Sub readShortcutsFromMenu(m As Menu)
	For Each mi As Object In m.MenuItems
		If mi Is Menu Then
			readShortcutsFromMenu(mi)
		else if mi Is MenuItem Then
			Dim jo As JavaObject = mi
			Dim accelerator As JavaObject = jo.RunMethod("getAccelerator",Null)
			If accelerator.IsInitialized Then
				Dim acceleratorString As String = accelerator.RunMethod("toString",Null)
				Dim menuItem1 As MenuItem = mi
				shortcuts.Put(menuItem1.Text,acceleratorString)
			End If
		End If
	Next
End Sub

Private Sub OkayButton_MouseClicked (EventData As MouseEvent)
	updateShortcutsMap
	frm.Close
End Sub

Private Sub Button1_MouseClicked (EventData As MouseEvent)
	Dim btn As Button = Sender
	Dim p As Pane = btn.Parent
	Dim tf As TextField = p.GetNode(1)
	Dim keyCombinationInput As KeyCombinationInputForm
	keyCombinationInput.Initialize
	Dim combo As String =  keyCombinationInput.showAndWait
	If combo <> "" Then
		If hasDuplication(combo) = False Then
			tf.Text = combo
		Else
			fx.Msgbox(frm,"其它项目已经使用了这一快捷键组合","")
		End If
	End If
End Sub

private Sub updateShortcutsMap
	For Each p As Pane In ShortcutsListView.Items
		Dim lbl As Label = p.GetNode(0)
		Dim tf As TextField = p.GetNode(1)
		If tf.Text <> "" Then
			shortcuts.Put(lbl.Text,tf.Text)
		Else
			shortcuts.Remove(lbl.Text)
		End If
	Next
End Sub

private Sub hasDuplication(combo As String) As Boolean
	For Each p As Pane In ShortcutsListView.Items
		Dim tf As TextField = p.GetNode(1)
		If combo = tf.Text Then
			Return True
		End If
	Next
	Return False
End Sub