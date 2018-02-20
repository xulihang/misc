Type=Class
Version=2.75
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'################################
'# Class:   ToastMsg (iOS)      #
'# Version: 1.0                 #
'# Author:  Pendrush            #
'################################


Sub Class_Globals

	Private pgParent As Page
	Private pnlMessage As Panel
	Private lblMessage As Label
	Private tmrTimer As Timer
	Private tmrTimer2 As Timer

End Sub


'Initializes the object.
'Pg - Parent page
'TextSize - Toast message font size
'Shadow - Show shadow
Public Sub Initialize (ParentPage As Page, TextSize As Float, Shadow As Boolean)

	pgParent = ParentPage
	If TextSize < 10 Then TextSize = 10
	tmrTimer.Initialize("tmrTimer", 500)
	tmrTimer.Enabled = False
	tmrTimer2.Initialize("tmrTimer2", 300)
	tmrTimer2.Enabled = False
	pnlMessage.Initialize("pnlMessage")	
	pnlMessage.Color = Colors.ARGB(200, 0, 0, 0)

	lblMessage.Initialize("")
	lblMessage.TextColor = Colors.White
	lblMessage.TextAlignment = lblMessage.ALIGNMENT_CENTER
	lblMessage.Font = Font.CreateNew(TextSize)
	lblMessage.Multiline = True
	
	pnlMessage.AddView(lblMessage, 0, 0, 10, 10)
	pnlMessage.SetBorder(0, Colors.Black, 10)
		
	pgParent.RootPanel.AddView(pnlMessage, 0, 0, pgParent.RootPanel.Width, pgParent.RootPanel.Height)
	
	If Shadow Then
		pnlMessage.SetShadow(Colors.Black, 0, 0, 0.8, False)
	End If
	pnlMessage.SetAlphaAnimated(1, 0)
	pnlMessage.Visible = False
		
End Sub


'Message - Toast message
'tInterval - Message display time, interval is in miliseconds (1000 = 1 seconds)
Public Sub ShowToastMessage(Message As String, tInterval As Int)
		
	tmrTimer.Enabled = False
	tmrTimer2.Enabled = False
	If tInterval <= 0 Then tInterval = 500
	tmrTimer.Interval = tInterval
	pnlMessage.Width = (pgParent.RootPanel.Width / 100) * 90
	pnlMessage.Left = pgParent.RootPanel.Width / 2 - pnlMessage.Width / 2
	lblMessage.SetLayoutAnimated(0, 0, 10, 10, pnlMessage.Width-20, 10)
	lblMessage.Text = Message
	lblMessage.SizeToFit
	pnlMessage.Height = lblMessage.Height + 20
	pnlMessage.Width = lblMessage.Width + 20
	
	pnlMessage.Left = pgParent.RootPanel.Width / 2 - pnlMessage.Width / 2
	pnlMessage.Top  = pgParent.RootPanel.Height / 2 - pnlMessage.Height / 2
			
	pnlMessage.Visible = True
	pnlMessage.BringToFront
	pnlMessage.SetAlphaAnimated(300, 1)
	tmrTimer.Enabled = True

End Sub


Public Sub HideMessage
	
	tmrTimer_Tick
	
End Sub


Private Sub tmrTimer_Tick
	
	tmrTimer.Enabled = False
	pnlMessage.SetAlphaAnimated(300, 0)
	tmrTimer2.Enabled = True
			
End Sub


Private Sub tmrTimer2_Tick
	
	tmrTimer2.Enabled = False
	pnlMessage.SendToBack
	pnlMessage.Visible = False
		
End Sub


Private Sub pnlMessage_Touch(Action As Int, X As Float, Y As Float)
	
	HideMessage
	
End Sub

