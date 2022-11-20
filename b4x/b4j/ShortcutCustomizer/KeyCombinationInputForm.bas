B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.9
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private frm As Form
	Private CombinationLabel As Label
	Private pressed As Boolean
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	frm.Initialize("frm",300,150)
	frm.RootPane.LoadLayout("KeyCombinationInput")
	AddKeyPressedEvent(frm.RootPane)
End Sub

public Sub showAndWait As String
	frm.ShowAndWait
	If pressed Then
		Return CombinationLabel.Text
	Else
		Return ""
	End If
End Sub

Private Sub OkayButton_MouseClicked (EventData As MouseEvent)
	frm.Close
End Sub

Private Sub AddKeyPressedEvent(n As Node)
	Dim r As Reflector
	r.Target = n
	r.AddEventHandler("keyreleased", "javafx.scene.input.KeyEvent.KEY_RELEASED")
End Sub


private Sub KeyReleased_Event (e As Event)
	Log("released")
	Dim jo As JavaObject = e
	Dim keycode As String = jo.RunMethod("getCode", Null)
	Dim text As String = jo.RunMethod("getText", Null)
	Log(e)
	Log(keycode)
	Log(jo.RunMethod("isAltDown",Null))
	Log(jo.RunMethod("isControlDown",Null))
	Log(jo.RunMethod("isMetaDown",Null))
	Log(jo.RunMethod("isShiftDown",Null))
	Log(jo.RunMethod("isShortcutDown",Null))
	If hasModifiersDown(e) Then
		If text <> "" Then
			CombinationLabel.Text = getKeyCombinationText(e)
			pressed = True
		End If
	Else
		If keycode.StartsWith("F") Then 'function keys
			CombinationLabel.Text = keycode
			pressed = True
		End If
	End If
End Sub

private Sub hasModifiersDown(e As JavaObject) As Boolean
	If e.RunMethod("isAltDown",Null) Or e.RunMethod("isControlDown",Null) Or e.RunMethod("isMetaDown",Null) Or e.RunMethod("isShiftDown",Null) Then
		Return True
	Else
		Return False
	End If
End Sub

private Sub getKeyCombinationText(e As JavaObject) As String
	Dim parts As List
	parts.Initialize
	If e.RunMethod("isControlDown",Null) Then
		parts.Add("Ctrl")
	End If
	If e.RunMethod("isMetaDown",Null) Then
		parts.Add("Command")
	End If
	If e.RunMethod("isAltDown",Null) Then
		parts.Add("Alt")
	End If
	If e.RunMethod("isShiftDown",Null) Then
		parts.Add("Shift")
	End If
	If e.RunMethod("getText",Null) <> "" Then
		parts.Add(e.RunMethod("getCode",Null))
	End If
	Log(parts)
	Dim sb As StringBuilder
	sb.Initialize
	Dim index As Int = 0
	For Each part As String In parts
		sb.Append(part)
		If index <> parts.Size - 1 Then
			sb.Append("+")
		End If
		index = index + 1
	Next
	Return sb.ToString
End Sub

