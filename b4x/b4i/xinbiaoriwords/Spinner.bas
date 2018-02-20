Type=Class
Version=2.75
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
#Event: ItemClick (index As Int, value As Object)
'++++++++++++++++++++++++++++++++++++++
'Class-Name	:	Spinner (for iOS)
'Version	:	0.20
'Author		:	Hugh Thomas
'
' Revision History
' 0.9   Initial release
' 0.10  Fix problem in spr.AddAll(). Was saving a reference to the passed list, not making a copy. 
'		Enabled flag not enforced correctly.
' 0.11  Fix itemList not initialised bug
' 0.20	1) Can now be added as a CustomView in the Designer
' 		2) Added spr.GetBase. If the Spinner was created in the Designer then spr.GetBase returns the Base Panel
'		   provided by the Designer. If the Spinner was created programmatically then spr.GetBase returns
' 		   the internal Spinner label. Note that spr.View always returns the internal Spinner Label.
'		3) Added spr.RemoveViewFromParent. Does the same things as spr.RemoveView. 
'		4) Fixed bug in IsInitialized()
'++++++++++++++++++++++++++++++++++++++
'Class module

' This class emulates the programmatic interface of the B4A Spinner. Internally it is implemented as 
' a label, which when clicked displays an Action Sheet for the user to make their selection.
' This view can be created in the Designer or programmatically. If created in the Designer then the 
' internal lblSpinner Label will be added within the Base Panel provided by the Designer.

' All of the methods in the B4A Spinner are implemented EXCEPT the following
'   Background     
'   DropdownBackgroundColor 
'   DropdownTextColor       
'   Invalidate    
'   Invalidate2   
'   Invalidate3   
'   Prompt
'   SetBackgroundImage
'   SetColorAnimated  
'   SetVisibleAnimated
'
' In addition, the following methods have been added:
' 	GetBase
' 	RemoveViewFromParent (same as RemoveView)
'   SetBorder
'   SetCallbackModule
'   View
'   TextAlignment attribute

Sub Class_Globals
	Private isInit      As Boolean = False
	Private pnlBase     As Panel
	Private lblSpinner  As Label
	Private CallBack    As Object
	Private mEventName  As String
	Private selectedIdx As Int
	Private itemList    As List
	Private actSheet    As ActionSheet
	Private isEnabled   As Boolean
	
	Public ALIGNMENT_CENTER As Int = lblSpinner.ALIGNMENT_CENTER 
	Public ALIGNMENT_LEFT   As Int = lblSpinner.ALIGNMENT_LEFT
	Public ALIGNMENT_RIGHT  As Int = lblSpinner.ALIGNMENT_RIGHT
End Sub

' The Spinner has been created in the Designer, so add  our internal label into the supplied base Panel,
' and copy the text attributes out of the supplied label
Public Sub DesignerCreateView (Base As Panel, Lbl As Label, Props As Map)
	pnlBase = Base

	' Copy text attributes to our internal Label
	lblSpinner.TextColor           = Lbl.TextColor
	lblSpinner.Font                = Lbl.Font
	lblSpinner.Multiline           = Lbl.Multiline
	lblSpinner.TextAlignment       = Lbl.TextAlignment
	lblSpinner.AdjustFontSizeToFit = Lbl.AdjustFontSizeToFit

	lblSpinner.Tag = pnlBase.Tag
	
	Base.AddView (lblSpinner, 0, 0, Base.Width, Base.Height)
End Sub

' Initializes the view and sets the subs that will handle the event. 
Public Sub Initialize(TargetModule As Object, EventName As String)
	mEventName = EventName 
	CallBack   = TargetModule
	
	isEnabled = True
	isInit    = True
	
	lblSpinner.Initialize("lblSpinner")
	lblSpinner.Color     = Colors.Transparent ' So we can see the base panel's background
	lblSpinner.Multiline = False
	lblSpinner.Text  = ""
	lblSpinner.TextAlignment = lblSpinner.ALIGNMENT_CENTER
	
	itemList.Initialize
	
	selectedIdx = 0
End Sub

' Add a list of items to the Spinner
public Sub AddAll (items As List)	
		
    Dim listCopy As List
    listCopy.Initialize
    listCopy.AddAll(items)
    itemList = listCopy

End Sub

'Adds a single item to the Spinner
public Sub Add (item As String)
	itemList.Add(item)
End Sub
	
' Sets the module containing the callback routine. eg: spr.SetCallbackModule(Me).
' If not called then callback routine is assumed to be in the main module) 
Sub SetCallbackModule (parentMod As Object)
	CallBack   = parentMod
End Sub

#region InternalCallbacks
Private Sub lblSpinner_Click
	actSheet.Initialize ("actSpinner", "", itemList.Get(selectedIdx),"", itemList)
	actSheet.Show (GetParent(lblSpinner))
End Sub
	
Sub actSpinner_Click (item As String)
	
	lblSpinner.Text = item
	selectedIdx = itemList.IndexOf (item)

	If SubExists(CallBack, mEventName & "_ItemClick", 2) Then
		CallSub3(CallBack, mEventName & "_ItemClick", selectedIdx, item)
	End If
End Sub
#End Region

#Region CustomViewCallBacks
' This will opnly be called if the Spinner was created in the Designer
Private Sub Base_Resize (Width As Double, Height As Double)
	lblSpinner.Width  = Width
	lblSpinner.Height = Height
End Sub
#End Region


#Region Class-Status

Public Sub IsInitialized As Boolean
	Return isInit
End Sub

Public Sub setVisible(Visible As Boolean)
	If (pnlBase.IsInitialized) Then
		pnlBase.Visible = Visible
	Else
		lblSpinner.Visible = Visible
	End If
End Sub

Public Sub getVisible As Boolean
	If (pnlBase.IsInitialized) Then
		Return pnlBase.Visible
	Else
		Return lblSpinner.Visible
	End If
End Sub

public Sub RequestFocus As Boolean
	Return lblSpinner.RequestFocus
End Sub

Public Sub setEnabled(enab As Boolean)
	isEnabled = enab
	lblSpinner.UserInteractionEnabled = isEnabled
	If isEnabled Then
		lblSpinner.Alpha = 1.0
	Else
		lblSpinner.Alpha = 0.3
	End If
End Sub

Public Sub getEnabled As Boolean
	Return isEnabled
End Sub
' Gets or sets the index of the selected item
Public Sub setSelectedIndex (idx As Int)
	selectedIdx = idx
	lblSpinner.Text = itemList.Get(idx)
End Sub

Public Sub getSelectedIndex As Int
	Return selectedIdx
End Sub

Public Sub getSelectedItem As String
	Return itemList.Get(selectedIdx)
End Sub

Public Sub GetItem (Index As Int) As String
	Return itemList.Get(Index)	
End Sub

Public Sub IndexOf (value As String) As Int
	Return itemList.IndexOf(value)
End Sub

' Returns the underlying Label used by the Spinner
Public Sub GetBase As View
	If pnlBase.IsInitialized Then 
		Return pnlBase
	Else
		Return lblSpinner
	End If
End Sub

Public Sub getView As View
	Return lblSpinner
End Sub
' Removes all items from the Spinner list
Public Sub Clear
	itemList.Clear
End Sub
' Returns the number of items in the Spinner list
Public Sub Size As Int
	Return itemList.Size
End Sub
#End Region

#Region TextFont
Public Sub getTextColor As Int
	Return lblSpinner.TextColor
End Sub
Public Sub setTextColor(Col As Int)
	lblSpinner.TextColor = Col
End Sub

Public Sub getTextSize As Int
	Return lblSpinner.Font.Size
End Sub
' Sets the size of the text in the Spinner label
Public Sub setTextSize(TextSize As Int)
	lblSpinner.Font = lblSpinner.Font.CreateNew(TextSize)
End Sub

' Gets or sets the text alignment. One of the ALIGNMENT constants
Public Sub getTextAlignment As Int
	Return lblSpinner.TextAlignment
End Sub

Public Sub setTextAlignment (align As Int)
	lblSpinner.TextAlignment = align
End Sub
#End Region

#Region Position
Public Sub getLeft As Int
	If pnlBase.IsInitialized Then
		Return pnlBase.Left
	Else
		Return lblSpinner.Left
	End If
End Sub

Public Sub setLeft(Left As Int)
	If pnlBase.IsInitialized Then
		pnlBase.Left = Left
	Else
		lblSpinner.Left = Left		
	End If
End Sub

Public Sub getTop As Int
	If pnlBase.IsInitialized Then
		Return pnlBase.Top
	Else
		Return lblSpinner.Top
	End If
End Sub

Public Sub setTop(Top As Int)
	If pnlBase.IsInitialized Then
		pnlBase.Top = Top
	Else
		lblSpinner.Top = Top
	End If
End Sub

Public Sub getWidth As Int
	Return lblSpinner.Width
End Sub

Public Sub setWidth(Width As Int)
	If pnlBase.IsInitialized Then pnlBase.Width = Width
	lblSpinner.Width = Width
End Sub

Public Sub getHeight As Int
	Return lblSpinner.Height
End Sub
Public Sub setHeight(Height As Int)
	If pnlBase.IsInitialized Then pnlBase.Height = Height
	lblSpinner.Height = Height
End Sub

Public Sub setColor (color As Int)
	lblSpinner.Color = color
End Sub
' Changes the view position and size
public Sub SetLayout (left As Int, top As Int, width As Int, height As Int) 
	If pnlBase.IsInitialized Then
		pnlBase.Left   = left
		pnlBase.Top    = top
		pnlBase.Width  = width
		pnlBase.Height = height

		lblSpinner.Width  = width
		lblSpinner.Height = height
	Else
		lblSpinner.Left   = left
		lblSpinner.Top    = top
		lblSpinner.Width  = width
		lblSpinner.Height = height
	End If
End Sub

' Similar to SetLayout, but animates the change.
Public Sub SetLayoutAnimated (durationMS As Int, left As Int, top As Int, width As Int, height As Int) 
	If pnlBase.IsInitialized Then
		pnlBase.SetLayoutAnimated   (durationMS, 1.0, left, top, width, height)
		lblSpinner.SetLayoutAnimated(durationMS, 1.0, 0   , 0  , width, height)
	Else
		lblSpinner.SetLayoutAnimated   (durationMS, 1.0, left, top, width, height)		
	End If
End Sub
#End Region

#region Appearance

' ! Set the background border
Sub SetBorder (width As Float, colour As Int, radius As Float)
	lblSpinner.SetBorder (width, colour, radius)
End Sub

public Sub BringToFront 
	If pnlBase.IsInitialized Then
		pnlBase.BringToFront
	Else
		lblSpinner.BringToFront
	End If
End Sub

Public Sub SendToBack
	If pnlBase.IsInitialized Then
		pnlBase.SendToBack
	Else
		lblSpinner.SendToBack
	End If
End Sub

Public Sub RemoveView 
	If pnlBase.IsInitialized Then
		pnlBase.RemoveViewFromParent
	Else
		lblSpinner.RemoveViewFromParent
	End If
End Sub

' For consistency with other B4i views
Public Sub RemoveViewFromParent
	RemoveView
End Sub

#End Region

#Region Class Tag
Public Sub getTag As Object
	Return lblSpinner.Tag
End Sub
Public Sub setTag(Tag As Object)
	lblSpinner.Tag = Tag
End Sub
#End Region

Private Sub GetParent(v As View) As View
    Dim r As NativeObject = v
	Return r.GetField("superview") 
End Sub'Class module
