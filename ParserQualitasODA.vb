Imports System.Text
Imports System.Text.RegularExpressions
Imports UglyToad.PdfPig
Imports UglyToad.PdfPig.Content

' Parser robusto para ODA Quálitas con normalización y heurísticas.
' Requiere NuGet: UglyToad.PdfPig
Public Module PdfQualitasODA

    ' === Lee TODO el texto del PDF (todas las páginas) ===
    Public Function ReadAllText(pdfPath As String) As String
        Dim sb As New StringBuilder()
        Using doc = PdfDocument.Open(pdfPath)
            For Each page In doc.GetPages()
                Dim t = page.Text
                If Not String.IsNullOrWhiteSpace(t) Then
                    sb.AppendLine(t)
                End If
            Next
        End Using
        Return sb.ToString()
    End Function

    ' === Parser principal para el ODA de Quálitas ===
    Public Function Parse(allText As String) As Dictionary(Of String, String)
        Dim result As New Dictionary(Of String, String)(StringComparer.OrdinalIgnoreCase)

        ' 1) Normalización básica
        Dim txt As String = allText
        ' Colapsa espacios múltiples
        txt = Regex.Replace(txt, "[ \t]+", " ")
        ' Inserta saltos antes y después de etiquetas clave (evita \R; usa vbCrLf)
        Dim labels As String = String.Join("|", New String() {
            "FOLIO ELECTR[ÓO]NICO",
            "N[°º\.]\s*\.?\s*SINIESTRO",
            "N[°º\.]\s*\.?\s*REPORTE",
            "N[°º\.]\s*DE P[ÓO]LIZA",
            "N[°º\.]\s*DE ENDOSO",
            "N[°º\.]\s*DE INCISO",
            "FECHA",
            "HORA",
            "ASEGURADO",
            "TERCERO\s+Q",
            "NOMBRE O RAZ[ÓO]N SOCIAL DEL CLIENTE",
            "RAZ[ÓO]N SOCIAL DEL CDR A DONDE SE ENVIAR[ÁA] EL VEH[ÍI]CULO",
            "TEL[ÉE]FONO",
            "E-?MAIL",
            "RESPONSABLE",
            "DOMICILIO\s*/?\s*COBERTURA",
            "MARCA",
            "TIPO",
            "MODELO\s*\(A[ÑN]O\)",
            "KILOMETRAJE",
            "COLOR",
            "N[°º\.]\s*DE SERIE",
            "TRANSMISI[ÓO]N",
            "PLACAS",
            "DESCRIPCI[ÓO]N DE DAÑOS A REPARAR"
        })

        txt = Regex.Replace(
            txt,
            "(?i)(" & labels & ")(\s*/)?",
            Function(m)
                Dim s = m.Groups(1).Value
                Dim slashOpt = If(m.Groups.Count > 2, m.Groups(2).Value, "")
                Return vbCrLf & s & If(String.IsNullOrEmpty(slashOpt), "", " /") & vbCrLf
            End Function
        )

        ' Limpia saltos repetidos
        txt = Regex.Replace(txt, "(\r?\n){2,}", vbCrLf)

        ' 2) Capturadores genéricos (toma la línea siguiente o el texto hasta la próxima etiqueta)
        Dim nextLabelRegex As String = "(" & labels & ")(?:\s*/)?"
        Dim valueUpToNextLabel As Func(Of String, String) =
            Function(labelPattern As String) As String
                Dim re As New Regex(labelPattern, RegexOptions.IgnoreCase)
                Dim m = re.Match(txt)
                If Not m.Success Then Return ""
                Dim start = m.Index + m.Length
                ' Desde el final de la etiqueta, toma hasta el siguiente label o fin
                Dim tail As String = txt.Substring(start)
                Dim stopM = Regex.Match(tail, nextLabelRegex, RegexOptions.IgnoreCase)
                Dim chunk As String = If(stopM.Success, tail.Substring(0, stopM.Index), tail)
                ' Primera línea no vacía
                Dim lines = chunk.Split({vbCrLf}, StringSplitOptions.RemoveEmptyEntries)
                If lines.Length = 0 Then Return ""
                Dim candidate = lines(0).Trim()
                ' Limpia residuos tipo / : - al inicio
                candidate = Regex.Replace(candidate, "^[/:\- ]+", "")
                Return candidate
            End Function

        ' 3) Extracciones

        ' FOLIO ELECTRÓNICO (en OCR puede verse "FOLION" pegado)
        Dim folioElectr = valueUpToNextLabel("FOLIO ELECTR[ÓO]NICO")
        If String.IsNullOrWhiteSpace(folioElectr) Then
            ' Fallback: busca ELECTRÓNICO seguido de un token
            folioElectr = Cap(txt, "ELECTR[ÓO]NICO\s*(?:\r?\n)?\s*([A-Z0-9\-]+)")
        End If
        result("FolioElectronico") = folioElectr

        ' N°. SINIESTRO / N°. REPORTE
        result("NoSiniestro") = valueUpToNextLabel("N[°º\.]\s*\.?\s*SINIESTRO")
        result("NoReporte") = valueUpToNextLabel("N[°º\.]\s*\.?\s*REPORTE")

        ' FECHA / HORA (regex directas)
        result("Fecha") = Cap(txt, "FECHA\s*(?:\r?\n)?\s*([0-9]{2}/[0-9]{2}/[0-9]{4})")
        result("Hora") = Cap(txt, "HORA\s*(?:\r?\n)?\s*([0-9]{2}:[0-9]{2}(?:\s*HRS?)?)")

        ' Póliza / Endoso / Inciso
        result("Poliza") = valueUpToNextLabel("N[°º\.]\s*DE P[ÓO]LIZA")
        result("Endoso") = valueUpToNextLabel("N[°º\.]\s*DE ENDOSO")
        result("Inciso") = valueUpToNextLabel("N[°º\.]\s*DE INCISO")

        ' ASEGURADO / TERCERO Q
        result("Asegurado") = valueUpToNextLabel("ASEGURADO")
        result("TerceroQ") = valueUpToNextLabel("TERCERO\s+Q")

        ' CLIENTE / CDR
        result("Cliente") = valueUpToNextLabel("NOMBRE O RAZ[ÓO]N SOCIAL DEL CLIENTE")
        result("RazonCDR") = valueUpToNextLabel("RAZ[ÓO]N SOCIAL DEL CDR A DONDE SE ENVIAR[ÁA] EL VEH[ÍI]CULO")

        ' Tel / Email / Responsable (regex y/o línea siguiente)
        Dim tel1 = Cap(txt, "TEL[ÉE]FONO\s*/?\s*(?:\r?\n)?\s*([0-9\(\)\-\s]{7,})")
        Dim tel2 = Cap(txt, "(?:^|\s)TEL[ÉE]FONO\s*(?:\r?\n)?\s*([0-9\(\)\-\s]{7,})")
        result("TelefonoCliente") = If(Not String.IsNullOrWhiteSpace(tel1), tel1, tel2)

        result("EmailCliente") = Cap(txt, "E-?MAIL\s*/?\s*(?:\r?\n)?\s*([A-Z0-9._%+\-]+@[A-Z0-9.\-]+\.[A-Z]{2,})", RegexOptions.IgnoreCase)
        If String.IsNullOrWhiteSpace(result("EmailCliente")) Then
            ' Fallback: primer email en todo el texto
            result("EmailCliente") = Cap(txt, "([A-Z0-9._%+\-]+@[A-Z0-9.\-]+\.[A-Z]{2,})", RegexOptions.IgnoreCase)
        End If

        result("Responsable") = valueUpToNextLabel("RESPONSABLE")

        ' DOMICILIO / COBERTURA (bloque)
        result("DomicilioCobertura") = valueUpToNextLabel("DOMICILIO\s*/?\s*COBERTURA")

        ' === Vehículo ===
        ' Heurística: Marca entre "COBERTURA /" y "MARCA", permitir comillas dobles en la clase de caracteres → "" (doblar comillas en VB)
        Dim marcaFromCob = Cap(txt, "COBERTURA\s*/\s*([A-Z0-9ÁÉÍÓÚÑ""'\.\-\s]+?)\s*MARCA", RegexOptions.IgnoreCase)
        Dim marca As String
        If Not String.IsNullOrWhiteSpace(marcaFromCob) Then
            marca = marcaFromCob.Trim()
        Else
            ' Siguiente a "MARCA"
            marca = valueUpToNextLabel("MARCA")
        End If
        result("Marca") = LimpiarValor(marca)

        ' Tipo: lo que sigue a MARCA hasta TIPO, o valor de TIPO
        Dim tipoFromSec = Cap(txt, "MARCA\s*(?:\r?\n)+\s*([^\r\n]+?)\s*(?:\r?\n)+\s*TIPO", RegexOptions.IgnoreCase)
        Dim tipo As String = If(Not String.IsNullOrWhiteSpace(tipoFromSec), tipoFromSec, valueUpToNextLabel("TIPO"))
        result("Tipo") = LimpiarValor(tipo)

        ' Modelo (año)
        result("ModeloAnio") = Cap(txt, "MODELO\s*\(A[ÑN]O\)\s*(?:\r?\n)?\s*([0-9]{4})")

        ' Kilometraje
        result("Kilometraje") = valueUpToNextLabel("KILOMETRAJE")
        If String.IsNullOrWhiteSpace(result("Kilometraje")) Then
            result("Kilometraje") = Cap(txt, "KILOMETRAJE\s*(?:\r?\n)?\s*([0-9\.,]+)")
        End If

        ' Color
        result("Color") = LimpiarValor(valueUpToNextLabel("COLOR"))

        ' Serie (VIN) — busca VIN plausible (11–20 chars sin I/O/Q)
        Dim vinWM = Cap(txt, "(W[A-HJ-NPR-Z0-9]{10,19})", RegexOptions.IgnoreCase)
        Dim vinAny = Cap(txt, "\b([A-HJ-NPR-Z0-9]{11,20})\b", RegexOptions.IgnoreCase)
        result("NoSerie") = If(Not String.IsNullOrWhiteSpace(vinWM), vinWM, vinAny)

        ' Transmisión
        result("Transmision") = valueUpToNextLabel("TRANSMISI[ÓO]N")

        ' Placas
        result("Placas") = valueUpToNextLabel("PLACAS")
        If String.IsNullOrWhiteSpace(result("Placas")) Then
            result("Placas") = Cap(txt, "LICENSE PLATES\s*(?:\r?\n)?\s*([A-Z0-9\-]+)")
        End If

        ' Descripción de daños
        Dim desc = valueUpToNextLabel("DESCRIPCI[ÓO]N DE DAÑOS A REPARAR")
        If String.IsNullOrWhiteSpace(desc) Then
            desc = Cap(txt, "DESCRIPCI[ÓO]N DE DAÑOS A REPARAR.*?(?:\r?\n)+\s*([^\r\n]+)",
                       RegexOptions.IgnoreCase Or RegexOptions.Singleline)
        End If
        result("DescripcionDanios") = LimpiarValor(desc)

        Return result
    End Function

    ' ---------- Helpers ----------
    Private Function Cap(source As String,
                         pattern As String,
                         Optional flags As RegexOptions = RegexOptions.Multiline) As String
        Dim m As Match = Regex.Match(source, pattern, flags Or RegexOptions.IgnoreCase)
        If m.Success AndAlso m.Groups.Count > 1 Then
            Return m.Groups(1).Value.Trim()
        End If
        Return ""
    End Function

    Private Function LimpiarValor(s As String) As String
        If String.IsNullOrWhiteSpace(s) Then Return ""
        Dim v = s.Trim()
        ' Borra “/”, “:” o residuos al inicio/fin
        v = Regex.Replace(v, "^[/:\- ]+|[/:\- ]+$", "")
        ' Compacta espacios
        v = Regex.Replace(v, "\s{2,}", " ")
        Return v
    End Function

End Module
