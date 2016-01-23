Attribute VB_Name = "Ä£¿é1"
Public Function getHoroscope(month As Integer, bornDate As Integer) As String
    If (month = 1) And (bornDate <= 19) Then
        getHoroscope = "Ä¦ôÉ×ù"
    ElseIf (month = 1) And (bornDate > 19) Then
        getHoroscope = "Ë®Æ¿×ù"
    ElseIf (month = 2) And (bornDate <= 18) Then
        getHoroscope = "Ë®Æ¿×ù"
    ElseIf (month = 2) And (bornDate > 18) Then
        getHoroscope = "Ë«Óã×ù"
    ElseIf (month = 3) And (bornDate <= 20) Then
        getHoroscope = "Ë«Óã×ù"
    ElseIf (month = 3) And (bornDate > 20) Then
        getHoroscope = "°×Ñò×ù"
    ElseIf (month = 4) And (bornDate <= 19) Then
        getHoroscope = "°×Ñò×ù"
    ElseIf (month = 4) And (bornDate > 19) Then
        getHoroscope = "½ðÅ£×ù"
    ElseIf (month = 5) And (bornDate <= 20) Then
        getHoroscope = "½ðÅ£×ù"
    ElseIf (month = 5) And (bornDate > 20) Then
        getHoroscope = "Ë«×Ó×ù"
    ElseIf (month = 6) And (bornDate <= 21) Then
        getHoroscope = "Ë«×Ó×ù"
    ElseIf (month = 6) And (bornDate > 21) Then
        getHoroscope = "¾ÞÐ·×ù"
    ElseIf (month = 7) And (bornDate <= 22) Then
        getHoroscope = "¾ÞÐ·×ù"
    ElseIf (month = 7) And (bornDate > 22) Then
        getHoroscope = "Ê¨×Ó×ù"
    ElseIf (month = 8) And (bornDate <= 22) Then
        getHoroscope = "Ê¨×Ó×ù"
    ElseIf (month = 8) And (bornDate > 22) Then
        getHoroscope = "´¦Å®×ù"
    ElseIf (month = 9) And (bornDate <= 22) Then
        getHoroscope = "´¦Å®×ù"
    ElseIf (month = 9) And (bornDate > 22) Then
        getHoroscope = "ÌìèÒ×ù"
    ElseIf (month = 10) And (bornDate <= 23) Then
        getHoroscope = "ÌìèÒ×ù"
    ElseIf (month = 10) And (bornDate > 23) Then
        getHoroscope = "ÌìÐ«×ù"
    ElseIf (month = 11) And (bornDate <= 22) Then
        getHoroscope = "ÌìÐ«×ù"
    ElseIf (month = 11) And (bornDate > 22) Then
        getHoroscope = "ÉäÊÖ×ù"
    ElseIf (month = 12) And (bornDate <= 21) Then
        getHoroscope = "ÉäÊÖ×ù"
    ElseIf (month = 12) And (bornDate > 21) Then
        getHoroscope = "Ä§ôÉ×ù"
    Else
        getHoroscope = "ÇëÊäÈëÉúÈÕ"
    End If
End Function
