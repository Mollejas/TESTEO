Public Class TotalesRubro
    Private idx As Integer = 0
    Public Subtotal As Decimal
    Public IVA As Decimal
    Public Total As Decimal

    Public Sub Asignar(valor As Decimal)
        If idx = 0 Then Subtotal = valor
        If idx = 1 Then IVA = valor
        If idx = 2 Then Total = valor
        idx += 1
    End Sub

    Public Function Formato() As String
        Return $"Subtotal: {Subtotal:C} | IVA: {IVA:C} | Total: {Total:C}"
    End Function
End Class
