Imports System.IO
Imports System.Text.RegularExpressions
Imports System.Data
Imports System.Data.SqlClient
Imports iTextSharp.text.pdf
Imports iTextSharp.text.pdf.parser
Imports Path = System.IO.Path

Public Class ProcesarODA
        Inherits System.Web.UI.Page

        ' Cadena de conexión - ajustar según tu configuración
        Private connectionString As String = "Data Source=TU_SERVIDOR;Initial Catalog=TU_BD;Integrated Security=True"

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                ' Inicialización si es necesaria
            End If
        End Sub

        Protected Sub btnProcesar_Click(sender As Object, e As EventArgs)
            Try
                If fuArchivos.HasFiles Then
                    Dim archivosProcesados As Integer = 0
                    Dim archivosConError As Integer = 0

                    For Each archivo As HttpPostedFile In fuArchivos.PostedFiles
                        If archivo.ContentLength > 0 AndAlso Path.GetExtension(archivo.FileName).ToLower() = ".pdf" Then
                            Try
                                Dim textoExtraido As String = ExtraerTextoDePDF(archivo.InputStream)
                                ProcesarTextoODA(textoExtraido)
                                archivosProcesados += 1
                            Catch ex As Exception
                                archivosConError += 1
                                ' Log del error
                            End Try
                        End If
                    Next

                    MostrarMensaje($"Archivos procesados: {archivosProcesados}. Errores: {archivosConError}", "success")
                Else
                    MostrarMensaje("Por favor seleccione al menos un archivo PDF.", "error")
                End If
            Catch ex As Exception
                MostrarMensaje($"Error al procesar archivos: {ex.Message}", "error")
            End Try
        End Sub

        Private Function ExtraerTextoDePDF(stream As Stream) As String
            Dim texto As New StringBuilder()
            Try
                Using reader As New PdfReader(stream)
                    For i As Integer = 1 To reader.NumberOfPages
                        texto.Append(PdfTextExtractor.GetTextFromPage(reader, i))
                    Next
                End Using
            Catch ex As Exception
                Throw New Exception("Error al extraer texto del PDF: " & ex.Message)
            End Try
            Return texto.ToString()
        End Function

        Private Sub ProcesarTextoODA(texto As String)
            Try
                ' Limpiar el texto de saltos de línea múltiples
                texto = Regex.Replace(texto, "\r\n|\r|\n", vbLf)
                texto = Regex.Replace(texto, "\s+", " ")

                ' ============ FOLIO ELECTRÓNICO ============
                ' Buscar después de "FOLIO ELECTRÓNICO" hasta el siguiente campo
                Dim folioElecMatch As Match = Regex.Match(texto, "FOLIO ELECTRÓNICO\s+([A-Z0-9]+)", RegexOptions.IgnoreCase)
                If folioElecMatch.Success Then
                    txtFolioElectronico.Text = folioElecMatch.Groups(1).Value.Trim()
                End If

                ' ============ FOLIO ============
                Dim folioMatch As Match = Regex.Match(texto, "FOLIO\s+(\d+)", RegexOptions.IgnoreCase)
                If folioMatch.Success Then
                    txtFolio.Text = folioMatch.Groups(1).Value.Trim()
                End If

                ' ============ NÚMERO DE SINIESTRO ============
                Dim siniestroMatch As Match = Regex.Match(texto, "N°\.\s*SINIESTRO\s+(\d+)", RegexOptions.IgnoreCase)
                If siniestroMatch.Success Then
                    txtSiniestro.Text = siniestroMatch.Groups(1).Value.Trim()
                End If

                ' ============ NÚMERO DE REPORTE ============
                Dim reporteMatch As Match = Regex.Match(texto, "N°\.\s*REPORTE\s+(\d+)", RegexOptions.IgnoreCase)
                If reporteMatch.Success Then
                    txtReporte.Text = reporteMatch.Groups(1).Value.Trim()
                End If

                ' ============ PÓLIZA, ENDOSO, INCISO ============
                ' Buscar la línea completa que contiene los tres valores
                Dim polizaLineMatch As Match = Regex.Match(texto, "(\d{14})\s+(\d{6})\s+N°\s+DE\s+PÓLIZA")
                If polizaLineMatch.Success Then
                    txtPoliza.Text = polizaLineMatch.Groups(1).Value
                    txtEndoso.Text = polizaLineMatch.Groups(2).Value
                End If

                ' Buscar inciso separado
                Dim incisoMatch As Match = Regex.Match(texto, "N°\s+DE\s+INCISO\s+/")
                If incisoMatch.Success Then
                    txtInciso.Text = "000000" ' Valor por defecto del documento
                End If

                ' ============ FECHA ============
                Dim fechaMatch As Match = Regex.Match(texto, "FECHA\s+/\s+(\d{2}/\d{2}/\d{4})")
                If fechaMatch.Success Then
                    Dim fechaStr As String = fechaMatch.Groups(1).Value
                    Dim fechaParts As String() = fechaStr.Split("/"c)
                    If fechaParts.Length = 3 Then
                        ' Convertir DD/MM/YYYY a YYYY-MM-DD
                        txtFecha.Text = $"{fechaParts(2)}-{fechaParts(1)}-{fechaParts(0)}"
                    End If
                End If

                ' ============ HORA ============
                Dim horaMatch As Match = Regex.Match(texto, "HORA\s+/\s+(\d{2}:\d{2}\s+HRS?)")
                If horaMatch.Success Then
                    txtHora.Text = horaMatch.Groups(1).Value.Trim()
                End If

                ' ============ ASEGURADO / TERCERO (NOMBRE DEL CLIENTE REAL) ============
                ' El nombre del cliente está en la línea ASEGURADO / TERCERO Q
                Dim aseguradoMatch As Match = Regex.Match(texto, "(?:ASEGURADO\s*/|TERCERO\s+Q\s*/)\s*([A-ZÁÉÍÓÚÑ\s]+?)\s+NOMBRE\s+O\s+RAZÓN\s+SOCIAL", RegexOptions.IgnoreCase)
                If aseguradoMatch.Success Then
                    txtAsegurado.Text = aseguradoMatch.Groups(1).Value.Trim()
                End If

                ' ============ TELÉFONO DEL CLIENTE ============
                ' El teléfono está después de "NOMBRE O RAZÓN SOCIAL DEL CLIENTE"
                Dim telefonoMatch As Match = Regex.Match(texto, "NOMBRE O RAZÓN SOCIAL DEL CLIENTE\s*/\s*[A-ZÁÉÍÓÚÑ\s]+\s+TELÉFONO\s*/\s*([\d\s]+?)\s+E-MAIL", RegexOptions.IgnoreCase)
                If telefonoMatch.Success Then
                    txtTelefono.Text = telefonoMatch.Groups(1).Value.Trim().Replace(" ", "")
                Else
                    ' Buscar patrón alternativo
                    telefonoMatch = Regex.Match(texto, "RAZÓN SOCIAL DEL CLIENTE[^T]+TELÉFONO\s*/\s*([\d\s]+?)\s+E-MAIL", RegexOptions.IgnoreCase)
                    If telefonoMatch.Success Then
                        txtTelefono.Text = telefonoMatch.Groups(1).Value.Trim().Replace(" ", "")
                    End If
                End If

                ' ============ E-MAIL ============
                ' El email está después del teléfono del cliente
                Dim emailMatch As Match = Regex.Match(texto, "TELÉFONO\s*/\s*[\d\s]+\s+E-MAIL\s*/\s*([\w\.\-]+@[\w\.\-]+\.\w+)", RegexOptions.IgnoreCase)
                If emailMatch.Success Then
                    txtEmail.Text = emailMatch.Groups(1).Value.Trim()
                End If

                ' ============ CDR (Centro de Reparación) ============
                Dim cdrMatch As Match = Regex.Match(texto, "RAZÓN SOCIAL DEL CDR[^/]*/?\s+([A-ZÁÉÍÓÚÑ\s]+?)\s+TELÉFONO", RegexOptions.IgnoreCase)
                If cdrMatch.Success Then
                    txtCDR.Text = cdrMatch.Groups(1).Value.Trim()
                End If

                ' ============ TELÉFONO CDR ============
                ' Buscar el segundo teléfono (después de RAZÓN SOCIAL DEL CDR)
                Dim matches As MatchCollection = Regex.Matches(texto, "TELÉFONO\s+([\d\s]+)")
                If matches.Count >= 2 Then
                    txtTelefonoCDR.Text = matches(1).Value.Replace("TELÉFONO", "").Trim().Replace(" ", "")
                End If

                ' ============ RESPONSABLE ============
                Dim responsableMatch As Match = Regex.Match(texto, "RESPONSABLE\s+([A-ZÁÉÍÓÚÑ\s]+?)\s+(?:DAÑOS|DOMICILIO)", RegexOptions.IgnoreCase)
                If responsableMatch.Success Then
                    txtResponsable.Text = responsableMatch.Groups(1).Value.Trim()
                End If

                ' ============ COBERTURA ============
                Dim coberturaMatch As Match = Regex.Match(texto, "COBERTURA\s+/\s+([A-ZÁÉÍÓÚÑ\s]+?)\s+(?:BMW|MARCA)", RegexOptions.IgnoreCase)
                If coberturaMatch.Success Then
                    txtCobertura.Text = coberturaMatch.Groups(1).Value.Trim()
                End If

                ' ============ DOMICILIO ============
                Dim domicilioMatch As Match = Regex.Match(texto, "([A-Z\s]+NO\.\d+[^,]+,[^,]+,[^,]+,\s*CP:\s*\d+)", RegexOptions.IgnoreCase)
                If domicilioMatch.Success Then
                    txtDomicilio.Text = domicilioMatch.Groups(1).Value.Trim()
                End If

                ' ============ MARCA ============
                Dim marcaMatch As Match = Regex.Match(texto, "MARCA\s+/\s+([A-Z]+)")
                If marcaMatch.Success Then
                    txtMarca.Text = marcaMatch.Groups(1).Value.Trim()
                End If

                ' ============ TIPO ============
                Dim tipoMatch As Match = Regex.Match(texto, "TIPO\s+/\s+([A-Z0-9\s""]+?)\s+MODELO", RegexOptions.IgnoreCase)
                If tipoMatch.Success Then
                    txtTipo.Text = tipoMatch.Groups(1).Value.Trim()
                End If

                ' ============ MODELO (AÑO) ============
                Dim modeloMatch As Match = Regex.Match(texto, "MODELO\s+\(AÑO\)\s+/\s+(\d{4})")
                If modeloMatch.Success Then
                    txtModelo.Text = modeloMatch.Groups(1).Value.Trim()
                End If

                ' ============ KILOMETRAJE ============
                Dim kmMatch As Match = Regex.Match(texto, "KILOMETRAJE\s+/\s+([\d,]+)")
                If kmMatch.Success Then
                    txtKilometraje.Text = kmMatch.Groups(1).Value.Trim()
                End If

                ' ============ COLOR ============
                Dim colorMatch As Match = Regex.Match(texto, "COLOR\s+([A-ZÁÉÍÓÚÑ]+)", RegexOptions.IgnoreCase)
                If colorMatch.Success Then
                    txtColor.Text = colorMatch.Groups(1).Value.Trim()
                End If

                ' ============ NÚMERO DE SERIE (VIN) ============
                Dim serieMatch As Match = Regex.Match(texto, "N°\.\s+DE\s+SERIE\s+/\s+([A-Z0-9]+)")
                If serieMatch.Success Then
                    txtSerie.Text = serieMatch.Groups(1).Value.Trim()
                End If

                ' ============ PLACAS ============
                Dim placasMatch As Match = Regex.Match(texto, "PLACAS\s+/\s+([A-Z0-9\-]+)")
                If placasMatch.Success Then
                    txtPlacas.Text = placasMatch.Groups(1).Value.Trim()
                End If

                ' ============ TRANSMISIÓN ============
                Dim transmisionMatch As Match = Regex.Match(texto, "TRANSMISIÓN\s+/\s+([A-Z]+)")
                If transmisionMatch.Success Then
                    txtTransmision.Text = transmisionMatch.Groups(1).Value.Trim()
                End If

                ' ============ DESCRIPCIÓN DE DAÑOS ============
                Dim danosMatch As Match = Regex.Match(texto, "DESCRIPTION OF DAMAGES TO REPAIR\s+([A-ZÁÉÍÓÚÑ,\s]+?)(?:SINO|APLICA)", RegexOptions.IgnoreCase)
                If danosMatch.Success Then
                    txtDanos.Text = danosMatch.Groups(1).Value.Trim()
                Else
                    ' Buscar patrón alternativo
                    danosMatch = Regex.Match(texto, "(FACIA[^S]+)", RegexOptions.IgnoreCase)
                    If danosMatch.Success Then
                        txtDanos.Text = danosMatch.Groups(1).Value.Trim()
                    End If
                End If

                ' ============ DAÑOS PREEXISTENTES ============
                Dim danosPreMatch As Match = Regex.Match(texto, "DESCRIPCIÓN DE DAÑOS PREEXISTENTES[^A-Z]*([A-ZÁÉÍÓÚÑ\s]+?)(?:Manifiesto|ACEPTO)", RegexOptions.IgnoreCase)
                If danosPreMatch.Success Then
                    txtDanosPreexistentes.Text = danosPreMatch.Groups(1).Value.Trim()
                End If

                ' ============ TIPO DEDUCIBLE ============
                Dim tipoDeducibleMatch As Match = Regex.Match(texto, "TIPO\s+/[^A-Z]*([A-Z%\s]+?)\s+TALLER", RegexOptions.IgnoreCase)
                If tipoDeducibleMatch.Success Then
                    txtTipoDeducible.Text = tipoDeducibleMatch.Groups(1).Value.Trim()
                End If

                ' ============ PORCENTAJE DEDUCIBLE ============
                Dim porcDeducibleMatch As Match = Regex.Match(texto, "PORCENTAJE DED\.\s+%\s+(\d+)")
                If porcDeducibleMatch.Success Then
                    txtPorcentajeDeducible.Text = porcDeducibleMatch.Groups(1).Value & "%"
                End If

                ' ============ SUMA ASEGURADA ============
                Dim sumaAsegMatch As Match = Regex.Match(texto, "SUMA ASEGURADA\s+([\d,]+)")
                If sumaAsegMatch.Success Then
                    txtSumaAsegurada.Text = sumaAsegMatch.Groups(1).Value.Trim()
                End If

                ' ============ CANTIDAD DEDUCIBLE ============
                Dim cantDeducibleMatch As Match = Regex.Match(texto, "CANTIDAD\s+\$?\s*([\d,]+)")
                If cantDeducibleMatch.Success Then
                    txtCantidadDeducible.Text = "$" & cantDeducibleMatch.Groups(1).Value.Trim()
                End If

                ' ============ AJUSTADOR ============
                Dim ajustadorMatch As Match = Regex.Match(texto, "(\d{5})\s+([A-ZÁÉÍÓÚÑ\s]+?)\s+(?:MIRIAM|[A-Z]{3,}\s+[A-Z]{3,})", RegexOptions.IgnoreCase)
                If ajustadorMatch.Success Then
                    txtClaveAjustador.Text = ajustadorMatch.Groups(1).Value.Trim()
                    txtAjustador.Text = ajustadorMatch.Groups(2).Value.Trim()
                End If

                ' ============ OBSERVACIONES Y ACUERDOS ============
                Dim observacionesSb As New StringBuilder()

                ' NIU
                If texto.Contains("NIU") Then
                    Dim niuMatch As Match = Regex.Match(texto, "(NIU[A-ZÁÉÍÓÚÑ\s]+)", RegexOptions.IgnoreCase)
                    If niuMatch.Success Then
                        observacionesSb.AppendLine("Tipo: " & niuMatch.Groups(1).Value.Trim())
                    End If
                End If

                ' Acuerdo Q
                Dim acuerdoMatch As Match = Regex.Match(texto, "ACUERDO\s+Q\s+(\d+%?)")
                If acuerdoMatch.Success Then
                    observacionesSb.AppendLine("Acuerdo Q: " & acuerdoMatch.Groups(1).Value)
                End If

                ' SIPAC
                If texto.Contains("SIPAC") Then
                    observacionesSb.AppendLine("Sistema: SIPAC")
                End If

                ' Daño menor a deducible
                If texto.Contains("DAÑO MENOR A DEDUCIBLE") Then
                    observacionesSb.AppendLine("Daño menor a deducible")
                End If

                txtObservaciones.Text = observacionesSb.ToString().Trim()

            Catch ex As Exception
                Throw New Exception("Error al procesar el texto: " & ex.Message)
            End Try
        End Sub

        Private Function ExtraerValor(texto As String, patron As String, Optional opciones As RegexOptions = RegexOptions.None) As String
            Try
                Dim match As Match = Regex.Match(texto, patron, opciones Or RegexOptions.IgnoreCase)
                If match.Success Then
                    ' Retorna el último grupo capturado que no sea el grupo 0 (match completo)
                    For i As Integer = match.Groups.Count - 1 To 1 Step -1
                        If Not String.IsNullOrWhiteSpace(match.Groups(i).Value) Then
                            Return match.Groups(i).Value.Trim()
                        End If
                    Next
                End If
            Catch ex As Exception
                ' Log del error si es necesario
            End Try
            Return String.Empty
        End Function

        Private Function ExtraerLinea(texto As String, palabraClave As String) As String
            Try
                Dim indice As Integer = texto.IndexOf(palabraClave, StringComparison.OrdinalIgnoreCase)
                If indice >= 0 Then
                    Dim finLinea As Integer = texto.IndexOf(vbLf, indice)
                    If finLinea > indice Then
                        Return texto.Substring(indice, finLinea - indice)
                    End If
                End If
            Catch ex As Exception
                ' Log del error
            End Try
            Return String.Empty
        End Function

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            MostrarMensaje("Formulario limpiado correctamente.", "success")
        End Sub

        Private Sub LimpiarFormulario()
            For Each ctrl As Control In form1.Controls
                LimpiarControles(ctrl)
            Next
        End Sub

        Private Sub LimpiarControles(parent As Control)
            For Each ctrl As Control In parent.Controls
                If TypeOf ctrl Is TextBox Then
                    DirectCast(ctrl, TextBox).Text = String.Empty
                End If
                If ctrl.HasControls() Then
                    LimpiarControles(ctrl)
                End If
            Next
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            Try
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    Dim query As String = "INSERT INTO OrdenesAdmision " &
                        "(FolioElectronico, Folio, Reporte, Siniestro, Poliza, Endoso, Inciso, " &
                        "Fecha, Hora, Asegurado, Telefono, Email, CDR, Domicilio, Responsable, " &
                        "TelefonoCDR, Cobertura, Marca, Tipo, Modelo, Color, Serie, Placas, " &
                        "Transmision, Kilometraje, Danos, DanosPreexistentes, TipoDeducible, " &
                        "PorcentajeDeducible, SumaAsegurada, CantidadDeducible, Ajustador, " &
                        "ClaveAjustador, Observaciones, FechaRegistro) " &
                        "VALUES (@FolioElectronico, @Folio, @Reporte, @Siniestro, @Poliza, @Endoso, @Inciso, " &
                        "@Fecha, @Hora, @Asegurado, @Telefono, @Email, @CDR, @Domicilio, @Responsable, " &
                        "@TelefonoCDR, @Cobertura, @Marca, @Tipo, @Modelo, @Color, @Serie, @Placas, " &
                        "@Transmision, @Kilometraje, @Danos, @DanosPreexistentes, @TipoDeducible, " &
                        "@PorcentajeDeducible, @SumaAsegurada, @CantidadDeducible, @Ajustador, " &
                        "@ClaveAjustador, @Observaciones, GETDATE())"

                    Using cmd As New SqlCommand(query, conn)
                        ' Agregar parámetros
                        cmd.Parameters.AddWithValue("@FolioElectronico", txtFolioElectronico.Text)
                        cmd.Parameters.AddWithValue("@Folio", txtFolio.Text)
                        cmd.Parameters.AddWithValue("@Reporte", txtReporte.Text)
                        cmd.Parameters.AddWithValue("@Siniestro", txtSiniestro.Text)
                        cmd.Parameters.AddWithValue("@Poliza", txtPoliza.Text)
                        cmd.Parameters.AddWithValue("@Endoso", txtEndoso.Text)
                        cmd.Parameters.AddWithValue("@Inciso", txtInciso.Text)
                        cmd.Parameters.AddWithValue("@Fecha", If(String.IsNullOrEmpty(txtFecha.Text), DBNull.Value, txtFecha.Text))
                        cmd.Parameters.AddWithValue("@Hora", txtHora.Text)
                        cmd.Parameters.AddWithValue("@Asegurado", txtAsegurado.Text)
                        cmd.Parameters.AddWithValue("@Telefono", txtTelefono.Text)
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text)
                        cmd.Parameters.AddWithValue("@CDR", txtCDR.Text)
                        cmd.Parameters.AddWithValue("@Domicilio", txtDomicilio.Text)
                        cmd.Parameters.AddWithValue("@Responsable", txtResponsable.Text)
                        cmd.Parameters.AddWithValue("@TelefonoCDR", txtTelefonoCDR.Text)
                        cmd.Parameters.AddWithValue("@Cobertura", txtCobertura.Text)
                        cmd.Parameters.AddWithValue("@Marca", txtMarca.Text)
                        cmd.Parameters.AddWithValue("@Tipo", txtTipo.Text)
                        cmd.Parameters.AddWithValue("@Modelo", txtModelo.Text)
                        cmd.Parameters.AddWithValue("@Color", txtColor.Text)
                        cmd.Parameters.AddWithValue("@Serie", txtSerie.Text)
                        cmd.Parameters.AddWithValue("@Placas", txtPlacas.Text)
                        cmd.Parameters.AddWithValue("@Transmision", txtTransmision.Text)
                        cmd.Parameters.AddWithValue("@Kilometraje", txtKilometraje.Text)
                        cmd.Parameters.AddWithValue("@Danos", txtDanos.Text)
                        cmd.Parameters.AddWithValue("@DanosPreexistentes", txtDanosPreexistentes.Text)
                        cmd.Parameters.AddWithValue("@TipoDeducible", txtTipoDeducible.Text)
                        cmd.Parameters.AddWithValue("@PorcentajeDeducible", txtPorcentajeDeducible.Text)
                        cmd.Parameters.AddWithValue("@SumaAsegurada", txtSumaAsegurada.Text)
                        cmd.Parameters.AddWithValue("@CantidadDeducible", txtCantidadDeducible.Text)
                        cmd.Parameters.AddWithValue("@Ajustador", txtAjustador.Text)
                        cmd.Parameters.AddWithValue("@ClaveAjustador", txtClaveAjustador.Text)
                        cmd.Parameters.AddWithValue("@Observaciones", txtObservaciones.Text)

                        cmd.ExecuteNonQuery()
                    End Using
                End Using

                MostrarMensaje("Información guardada correctamente en la base de datos.", "success")
            Catch ex As Exception
                MostrarMensaje($"Error al guardar en base de datos: {ex.Message}", "error")
            End Try
        End Sub

        Protected Sub btnExportar_Click(sender As Object, e As EventArgs)
            Try
                ' Crear DataTable con la información
                Dim dt As New DataTable("OrdenAdmision")

                ' Agregar columnas
                dt.Columns.Add("FolioElectronico")
                dt.Columns.Add("Folio")
                dt.Columns.Add("Reporte")
                dt.Columns.Add("Siniestro")
                dt.Columns.Add("Poliza")
                dt.Columns.Add("Endoso")
                dt.Columns.Add("Inciso")
                dt.Columns.Add("Fecha")
                dt.Columns.Add("Hora")
                dt.Columns.Add("Asegurado")
                dt.Columns.Add("Telefono")
                dt.Columns.Add("Email")
                dt.Columns.Add("CDR")
                dt.Columns.Add("Domicilio")
                dt.Columns.Add("Responsable")
                dt.Columns.Add("TelefonoCDR")
                dt.Columns.Add("Cobertura")
                dt.Columns.Add("Marca")
                dt.Columns.Add("Tipo")
                dt.Columns.Add("Modelo")
                dt.Columns.Add("Color")
                dt.Columns.Add("Serie")
                dt.Columns.Add("Placas")
                dt.Columns.Add("Transmision")
                dt.Columns.Add("Kilometraje")
                dt.Columns.Add("Danos")
                dt.Columns.Add("DanosPreexistentes")
                dt.Columns.Add("TipoDeducible")
                dt.Columns.Add("PorcentajeDeducible")
                dt.Columns.Add("SumaAsegurada")
                dt.Columns.Add("CantidadDeducible")
                dt.Columns.Add("Ajustador")
                dt.Columns.Add("ClaveAjustador")
                dt.Columns.Add("Observaciones")

                ' Agregar fila con datos
                Dim row As DataRow = dt.NewRow()
                row("FolioElectronico") = txtFolioElectronico.Text
                row("Folio") = txtFolio.Text
                row("Reporte") = txtReporte.Text
                row("Siniestro") = txtSiniestro.Text
                row("Poliza") = txtPoliza.Text
                row("Endoso") = txtEndoso.Text
                row("Inciso") = txtInciso.Text
                row("Fecha") = txtFecha.Text
                row("Hora") = txtHora.Text
                row("Asegurado") = txtAsegurado.Text
                row("Telefono") = txtTelefono.Text
                row("Email") = txtEmail.Text
                row("CDR") = txtCDR.Text
                row("Domicilio") = txtDomicilio.Text
                row("Responsable") = txtResponsable.Text
                row("TelefonoCDR") = txtTelefonoCDR.Text
                row("Cobertura") = txtCobertura.Text
                row("Marca") = txtMarca.Text
                row("Tipo") = txtTipo.Text
                row("Modelo") = txtModelo.Text
                row("Color") = txtColor.Text
                row("Serie") = txtSerie.Text
                row("Placas") = txtPlacas.Text
                row("Transmision") = txtTransmision.Text
                row("Kilometraje") = txtKilometraje.Text
                row("Danos") = txtDanos.Text
                row("DanosPreexistentes") = txtDanosPreexistentes.Text
                row("TipoDeducible") = txtTipoDeducible.Text
                row("PorcentajeDeducible") = txtPorcentajeDeducible.Text
                row("SumaAsegurada") = txtSumaAsegurada.Text
                row("CantidadDeducible") = txtCantidadDeducible.Text
                row("Ajustador") = txtAjustador.Text
                row("ClaveAjustador") = txtClaveAjustador.Text
                row("Observaciones") = txtObservaciones.Text
                dt.Rows.Add(row)

                ' Exportar a Excel (CSV)
                ExportarACSV(dt)

            Catch ex As Exception
                MostrarMensaje($"Error al exportar: {ex.Message}", "error")
            End Try
        End Sub

        Private Sub ExportarACSV(dt As DataTable)
            Response.Clear()
            Response.Buffer = True
            Response.AddHeader("content-disposition", $"attachment;filename=ODA_{DateTime.Now:yyyyMMddHHmmss}.csv")
            Response.Charset = "UTF-8"
            Response.ContentType = "text/csv"
            Response.ContentEncoding = System.Text.Encoding.UTF8

            ' Escribir BOM para UTF-8
            Response.BinaryWrite(System.Text.Encoding.UTF8.GetPreamble())

            Dim sb As New StringBuilder()

            ' Encabezados
            For i As Integer = 0 To dt.Columns.Count - 1
                sb.Append(dt.Columns(i).ColumnName)
                If i < dt.Columns.Count - 1 Then
                    sb.Append(",")
                End If
            Next
            sb.AppendLine()

            ' Datos
            For Each row As DataRow In dt.Rows
                For i As Integer = 0 To dt.Columns.Count - 1
                    Dim valor As String = row(i).ToString().Replace("""", """""")
                    If valor.Contains(",") OrElse valor.Contains(vbLf) Then
                        valor = """" & valor & """"
                    End If
                    sb.Append(valor)
                    If i < dt.Columns.Count - 1 Then
                        sb.Append(",")
                    End If
                Next
                sb.AppendLine()
            Next

            Response.Output.Write(sb.ToString())
            Response.Flush()
            Response.End()
        End Sub

        Private Sub MostrarMensaje(mensaje As String, tipo As String)
            lblMensaje.Text = mensaje
            lblMensaje.Visible = True

            If tipo = "success" Then
                lblMensaje.CssClass = "mensaje success"
            Else
                lblMensaje.CssClass = "mensaje error"
            End If
        End Sub

    End Class
