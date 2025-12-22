

Imports System
Imports System.Web
Imports System.IO
Imports System.Security.Principal

Public Class SavePdf : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "text/plain"
        context.Response.TrySkipIisCustomErrors = True

        Try
            Dim f = context.Request.Files("file")
            If f Is Nothing OrElse f.ContentLength = 0 Then
                context.Response.StatusCode = 400
                context.Response.Write("No se recibió archivo (key 'file' vacía).")
                Return
            End If

            ' Carpeta física de ~/inbursa/
            Dim saveDir As String = context.Server.MapPath("~/inbursa/")
            If Not Directory.Exists(saveDir) Then
                Directory.CreateDirectory(saveDir)
            End If

            ' Nombre seguro
            Dim safeName As String = Path.GetFileName(f.FileName)
            If String.IsNullOrWhiteSpace(safeName) Then
                safeName = "inspeccion_" & DateTime.Now.ToString("yyyyMMdd_HHmmss") & ".pdf"
            End If
            Dim fullPath As String = Path.Combine(saveDir, safeName)

            ' Guarda
            f.SaveAs(fullPath)

            ' Diagnóstico
            Dim user As String = WindowsIdentity.GetCurrent().Name
            Dim sizeKB As Decimal = Math.Round(f.ContentLength / 1024D, 2)

            context.Response.StatusCode = 200
            context.Response.Write("OK" & vbCrLf)
            context.Response.Write("Guardado en: " & fullPath & vbCrLf)
            context.Response.Write("Tam.: " & sizeKB & " KB" & vbCrLf)
            context.Response.Write("Usuario IIS: " & user & vbCrLf)
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write("ERROR" & vbCrLf)
            context.Response.Write("Mensaje: " & ex.Message & vbCrLf)
            If ex.InnerException IsNot Nothing Then
                context.Response.Write("Inner: " & ex.InnerException.Message & vbCrLf)
            End If
        End Try
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
