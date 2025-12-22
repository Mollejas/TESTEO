

Imports System
Imports System.IO
Imports System.Text
Imports System.Text.RegularExpressions


Public Class QUALITAS
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            lblStatus.Text = ""
        End If
    End Sub

    Protected Sub btnExtraer_Click(sender As Object, e As EventArgs) Handles btnExtraer.Click
        Try
            If Not fuPdf.HasFile Then
                lblStatus.Text = "Sube un PDF primero."
                Exit Sub
            End If

            ' Guardar temporalmente el PDF subido
            Dim tempPath = Server.MapPath("~/App_Data/uploads")
            If Not Directory.Exists(tempPath) Then Directory.CreateDirectory(tempPath)
            Dim filePath = Path.Combine(tempPath, Guid.NewGuid().ToString("N") & Path.GetExtension(fuPdf.FileName))
            fuPdf.SaveAs(filePath)

            ' Leer y parsear
            Dim txt As String = PdfQualitasODA.ReadAllText(filePath)
            Dim data = PdfQualitasODA.Parse(txt)

            ' Mapear a TextBoxes (usa TryGet para no reventar si falta algún campo)
            txtFolioElectronico.Text = data.TryGet("FolioElectronico")
            txtNoSiniestro.Text = data.TryGet("NoSiniestro")
            txtNoReporte.Text = data.TryGet("NoReporte")

            txtPoliza.Text = data.TryGet("Poliza")
            txtEndoso.Text = data.TryGet("Endoso")
            txtInciso.Text = data.TryGet("Inciso")
            txtFecha.Text = data.TryGet("Fecha")
            txtHora.Text = data.TryGet("Hora")

            txtAsegurado.Text = data.TryGet("Asegurado")
            txtTerceroQ.Text = data.TryGet("TerceroQ")

            txtCliente.Text = data.TryGet("Cliente")
            txtRazonCDR.Text = data.TryGet("RazonCDR")

            txtTelCliente.Text = data.TryGet("TelefonoCliente")
            txtEmailCliente.Text = data.TryGet("EmailCliente")
            txtResponsable.Text = data.TryGet("Responsable")
            txtDomicilioCobertura.Text = data.TryGet("DomicilioCobertura")

            txtMarca.Text = data.TryGet("Marca")
            txtTipo.Text = data.TryGet("Tipo")
            txtModeloAnio.Text = data.TryGet("ModeloAnio")
            txtKilometraje.Text = data.TryGet("Kilometraje")
            txtColor.Text = data.TryGet("Color")
            txtNoSerie.Text = data.TryGet("NoSerie")
            txtTransmision.Text = data.TryGet("Transmision")
            txtPlacas.Text = data.TryGet("Placas")

            txtDescripcionDanios.Text = data.TryGet("DescripcionDanios")

            lblStatus.Text = "Extracción completada."
        Catch ex As Exception
            lblStatus.Text = "Error: " & ex.Message
        End Try
    End Sub
End Class

' Helpers de acceso seguro al diccionario
Public Module DictExt
    <System.Runtime.CompilerServices.Extension>
    Public Function TryGet(d As System.Collections.Generic.Dictionary(Of String, String), key As String) As String
        If d Is Nothing Then Return ""
        Dim v As String = Nothing
        If d.TryGetValue(key, v) Then Return v
        Return ""
    End Function
End Module