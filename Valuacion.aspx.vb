Imports System.Data
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

        For Each linea In lineas

            Dim txt = linea.Trim()
            If txt = "" Then Continue For

            Dim txtU = txt.ToUpper()

            ' ==========================
            ' DETECTAR SECCIONES
            ' ==========================
            If txtU = "REFACCIONES" Then
                seccionActual = "REF"
                capturandoConceptos = False
                capturandoTotales = False
                Continue For
            End If

            If txtU.StartsWith("PINTURA") Then
                seccionActual = "PIN"
                capturandoConceptos = False
                capturandoTotales = False
                Continue For
            End If

            If txtU.StartsWith("MANO DE OBRA HOJALATERIA") Then
                seccionActual = "HOJ"
                capturandoConceptos = False
                capturandoTotales = False
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

                Dim montoMatch = Regex.Match(txt, "\$\s*([\d,]+\.\d{2})")
                If Not montoMatch.Success Then Continue For

                Dim monto = Decimal.Parse(montoMatch.Groups(1).Value.Replace(",", ""))
                Dim textoAntes = txt.Substring(0, montoMatch.Index).Trim()
                Dim partes = textoAntes.Split()

                If partes.Length < 2 Then Continue For

                Select Case seccionActual

                    ' --------------------------
                    ' REFACCIONES
                    ' --------------------------
                    Case "REF"
                        If Not textoAntes.Contains(":") Then
                            Dim desc = String.Join(" ", partes.Take(partes.Length - 1))
                            If desc <> "" Then dtRef.Rows.Add(desc, monto)
                        End If

                    ' --------------------------
                    ' PINTURA
                    ' --------------------------
                    Case "PIN"
                        If textoAntes.ToUpper().Contains(":PINT") _
                           OrElse textoAntes.ToUpper().Contains("TPP") Then

                            Dim desc = String.Join(" ", partes.Take(partes.Length - 1))
                            desc = Regex.Replace(desc, "\s+TPP\s*$", "", RegexOptions.IgnoreCase).Trim()
                            If desc <> "" Then dtPin.Rows.Add(desc, monto)
                        End If

                    ' --------------------------
                    ' MANO DE OBRA HOJALATERIA
                    ' --------------------------
                    Case "HOJ"
                        ' CLAVE: TODO con monto y que NO sea pintura
                        If Not textoAntes.ToUpper().Contains(":PINT") Then
                            Dim desc = String.Join(" ", partes.Take(partes.Length - 1))
                            If desc <> "" Then dtHoj.Rows.Add(desc, monto)
                        End If

                End Select
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

    Private Function ExtraerLineasRegion(reader As PdfReader, pagina As Integer, region As Rectangle) As IEnumerable(Of String)

        Dim strategy As New FilteredTextRenderListener(New LocationTextExtractionStrategy(), New RegionTextRenderFilter(region))
        Dim texto = PdfTextExtractor.GetTextFromPage(reader, pagina, strategy)

        Return texto.
            Split({vbLf, vbCr}, StringSplitOptions.RemoveEmptyEntries).
            Select(Function(l) l.Trim()).
            Where(Function(l) l <> "")
    End Function

End Class
