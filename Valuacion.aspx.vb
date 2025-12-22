Imports System.Data
Imports System.IO
Imports System.Text.RegularExpressions
Imports iTextSharp.text.pdf
Imports iTextSharp.text.pdf.parser
Imports iTextSharp.text
Imports System.Linq

Public Class Valuacion
    Inherits System.Web.UI.Page

    Protected Sub btnProcesar_Click(sender As Object, e As EventArgs) Handles btnProcesar.Click

        If Not fuPdf.HasFile Then Exit Sub

        Dim lineas = LeerPdfPorLineas(fuPdf.PostedFile.InputStream)

        Dim dtRef = CrearTabla()
        Dim dtPin = CrearTabla()
        Dim dtHoj = CrearTabla()

        Dim totRef As New TotalesRubro()
        Dim totPin As New TotalesRubro()
        Dim totHoj As New TotalesRubro()

        Dim seccionActual As String = ""
        Dim capturandoConceptos As Boolean = False
        Dim capturandoTotales As Boolean = False
        Dim descripcionPendiente As String = Nothing

        For Each linea In lineas

            Dim txt = linea.Trim()
            If txt = "" Then Continue For

            Dim txtU = txt.ToUpper()

            ' ==========================
            ' DETECTAR SECCIONES
            ' ==========================
            If txtU.Contains("REFACCIONES") Then
                seccionActual = "REF"
                capturandoConceptos = False
                capturandoTotales = False
                descripcionPendiente = Nothing
                Continue For
            End If

            If txtU.Contains("PINTURA") Then
                seccionActual = "PIN"
                capturandoConceptos = False
                capturandoTotales = False
                descripcionPendiente = Nothing
                Continue For
            End If

            If txtU.Contains("MANO DE OBRA HOJALATERIA") Then
                seccionActual = "HOJ"
                capturandoConceptos = False
                capturandoTotales = False
                descripcionPendiente = Nothing
                Continue For
            End If

            ' ==========================
            ' ENCABEZADO DESCRIPCION / MONTO
            ' ==========================
            If txtU.Contains("DESCRIPCION") AndAlso txtU.Contains("MONTO") Then
                capturandoConceptos = True
                Continue For
            End If

            ' ==========================
            ' INICIO DE TOTALES (CIERRA SECCION)
            ' ==========================
            If txtU = "SUBTOTAL" Then
                capturandoConceptos = False
                capturandoTotales = True
                descripcionPendiente = Nothing
                Continue For
            End If

            ' ==========================
            ' CAPTURAR SUB / IVA / TOTAL
            ' ==========================
            If capturandoTotales Then
                Dim m = Regex.Match(txt, "\$\s*([\d,]+\.\d{2})")
                If m.Success Then
                    Dim valor = Decimal.Parse(m.Groups(1).Value.Replace(",", ""))

                    Select Case seccionActual
                        Case "REF" : totRef.Asignar(valor)
                        Case "PIN" : totPin.Asignar(valor)
                        Case "HOJ" : totHoj.Asignar(valor)
                    End Select
                End If
                Continue For
            End If

            ' ==========================
            ' IGNORAR LINEAS NEUTRAS
            ' ==========================
            If txtU.StartsWith("UT") _
               Or txtU = "IVA" _
               Or txtU = "TOTAL" _
               Or txtU.Contains("NO EFECTIVO") Then Continue For

            ' ==========================
            ' CAPTURAR CONCEPTOS
            ' ==========================
            If capturandoConceptos Then

                Dim desc As String = Nothing
                Dim monto As Decimal

                If TryParseConcepto(txt, seccionActual, desc, monto) Then
                    descripcionPendiente = Nothing
                ElseIf descripcionPendiente IsNot Nothing AndAlso TryParseMonto(txt, monto) Then
                    desc = descripcionPendiente
                    descripcionPendiente = Nothing
                ElseIf TryParseDescripcionSinMonto(txt, seccionActual, desc) Then
                    descripcionPendiente = desc
                End If

                If desc IsNot Nothing Then
                    Select Case seccionActual
                        Case "REF"
                            dtRef.Rows.Add(desc, monto)
                        Case "PIN"
                            dtPin.Rows.Add(desc, monto)
                        Case "HOJ"
                            dtHoj.Rows.Add(desc, monto)
                    End Select
                End If
            End If

        Next

        ' ==========================
        ' BIND GRIDS
        ' ==========================
        gvRefacciones.DataSource = dtRef
        gvRefacciones.DataBind()

        gvPintura.DataSource = dtPin
        gvPintura.DataBind()

        gvHojalateria.DataSource = dtHoj
        gvHojalateria.DataBind()

        ' ==========================
        ' TOTALES ABAJO DE CADA GRID
        ' ==========================
        lblTotRef.Text = totRef.Formato()
        lblTotPintura.Text = totPin.Formato()
        lblTotHoj.Text = totHoj.Formato()

    End Sub

    ' ==========================
    ' CREA TABLA
    ' ==========================
    Private Function CrearTabla() As DataTable
        Dim dt As New DataTable()
        dt.Columns.Add("Descripcion", GetType(String))
        dt.Columns.Add("Monto", GetType(Decimal))
        Return dt
    End Function

    ' ==========================
    ' LECTURA PDF POR LINEAS
    ' ==========================
    Private Function LeerPdfPorLineas(stream As IO.Stream) As List(Of String)

        Dim reader As New PdfReader(stream)
        Dim resultado As New List(Of String)()

        For p = 1 To reader.NumberOfPages

            Dim tamano = reader.GetPageSize(p)
            Dim mitadX = tamano.Width / 2

            ' La hoja viene dividida en dos secciones (izquierda y derecha).
            ' Extraemos primero el bloque izquierdo (de arriba hacia abajo)
            ' y después el bloque derecho.
            Dim regionIzq As New Rectangle(0, 0, mitadX, tamano.Height)
            Dim regionDer As New Rectangle(mitadX, 0, tamano.Width, tamano.Height)

            resultado.AddRange(ExtraerLineasRegion(reader, p, regionIzq))
            resultado.AddRange(ExtraerLineasRegion(reader, p, regionDer))
        Next

        reader.Close()

        Return resultado
    End Function

    Private Function TryParseConcepto(linea As String, seccion As String, ByRef descripcion As String, ByRef monto As Decimal) As Boolean

        If Not linea.Contains("$") Then Return False

        Dim montoMatch As Match = Nothing
        If Not TryParseMontoMatch(linea, montoMatch) Then Return False

        Dim textoAntes = linea.Substring(0, montoMatch.Index).Trim()
        If textoAntes = "" Then Return False

        Dim textoUpper = textoAntes.ToUpper()
        If textoUpper = "TOTAL" OrElse textoUpper = "IVA" OrElse textoUpper = "UT" Then Return False

        Dim desc = Regex.Replace(textoAntes, "\s+TPP(\s+[\d.]+)?\s*$", "", RegexOptions.IgnoreCase).Trim()

        If EsConceptoBloqueado(desc) Then Return False

        If seccion = "PIN" AndAlso Not EsLineaPintura(textoUpper) Then Return False
        If seccion = "HOJ" AndAlso textoUpper.Contains(":PINT") Then Return False

        If desc.Length < 3 Then Return False

        descripcion = desc
        monto = Decimal.Parse(montoMatch.Groups(1).Value.Replace(",", ""))
        Return True
    End Function

    Private Function TryParseDescripcionSinMonto(linea As String, seccion As String, ByRef descripcion As String) As Boolean

        If linea.Contains("$") Then Return False

        Dim texto = linea.Trim()
        If texto = "" Then Return False

        Dim textoUpper = texto.ToUpper()
        If textoUpper = "TOTAL" OrElse textoUpper = "IVA" OrElse textoUpper = "UT" Then Return False

        Dim desc = Regex.Replace(texto, "\s+TPP(\s+[\d.]+)?\s*$", "", RegexOptions.IgnoreCase).Trim()
        If desc.Length < 3 Then Return False
        If EsConceptoBloqueado(desc) Then Return False

        If seccion = "PIN" AndAlso Not EsLineaPintura(textoUpper) Then Return False
        If seccion = "HOJ" AndAlso textoUpper.Contains(":PINT") Then Return False

        descripcion = desc
        Return True
    End Function

    Private Function TryParseMonto(linea As String, ByRef monto As Decimal) As Boolean

        ' Si la línea contiene TPP, es probable que sea la línea de monto para TIEMPO PREPARACION DE PINTURA
        ' que viene en línea separada, así que es válido para sección de pintura
        If linea.ToUpper().Contains("TPP") Then
            Dim montoMatch As Match = Nothing
            If Not TryParseMontoMatch(linea, montoMatch) Then Return False
            monto = Decimal.Parse(montoMatch.Groups(1).Value.Replace(",", ""))
            Return True
        End If

        Dim montoMatch2 As Match = Nothing
        If Not TryParseMontoMatch(linea, montoMatch2) Then Return False

        monto = Decimal.Parse(montoMatch2.Groups(1).Value.Replace(",", ""))
        Return True
    End Function

    Private Function TryParseMontoMatch(linea As String, ByRef montoMatch As Match) As Boolean
        ' Primero intenta encontrar un monto con símbolo de peso
        montoMatch = Regex.Match(linea, "\$\s*([\d,]+\.\d{2})", RegexOptions.RightToLeft)
        If montoMatch.Success Then Return True

        ' Si no, busca cualquier número con formato de moneda (dígitos, comas, punto y 2 decimales)
        montoMatch = Regex.Match(linea, "([\d]{1,3}(?:,\d{3})*\.\d{2})", RegexOptions.RightToLeft)
        Return montoMatch.Success
    End Function

    Private Function EsLineaPintura(textoUpper As String) As Boolean
        Return textoUpper.Contains(":PINT") _
            OrElse textoUpper.Contains("TPP") _
            OrElse textoUpper.Contains("PINTURA") _
            OrElse textoUpper.Contains("PREPARACION")
    End Function

    Private Function EsConceptoBloqueado(descripcion As String) As Boolean

        Dim descUpper = descripcion.ToUpper()
        Dim descSinAcentos = descUpper.Replace("É", "E")

        Dim bloqueados As String() = {
            "SUMA TOTAL SIN IVA",
            "16% IVA",
            "SUMA TOTAL VAL CON IVA",
            "DEDUCIBLE",
            "DEMERITO",
            "SUBTOTAL",
            "IVA",
            "TOTAL"
        }

        Return bloqueados.Any(Function(b) descSinAcentos.Contains(b))
    End Function

    Private Function ExtraerLineasRegion(reader As PdfReader, pagina As Integer, region As Rectangle) As IEnumerable(Of String)

        Dim strategy As New FilteredTextRenderListener(New LocationTextExtractionStrategy(), New RegionTextRenderFilter(region))
        Dim texto = PdfTextExtractor.GetTextFromPage(reader, pagina, strategy)

        Return texto.
            Split({vbLf, vbCr}, StringSplitOptions.RemoveEmptyEntries).
            Select(Function(l) l.Trim()).
            Where(Function(l) l <> "")
    End Function

End Class
