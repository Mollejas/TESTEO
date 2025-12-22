Imports System
Imports System.Collections.Generic

Partial Public Class InventarioDaytona
        Inherits System.Web.UI.Page

        Protected Class Campo
            Public Property Key As String
            Public Property Label As String
        End Class

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                ' Fecha por defecto = hoy
                If String.IsNullOrWhiteSpace(txtFechaExp.Text) Then
                    txtFechaExp.Text = DateTime.Now.ToString("yyyy-MM-dd")
                End If

                ' Bind de todas las secciones
                BindSection(rptLiquidos, "liq", New String() {
                    "ANTICONGELANTE", "ACEITE DE MOTOR", "ACEITE DE TRANS", "LIQUIDO DE FRENOS"
                })

                BindSection(rptMotor, "motor", New String() {
                    "VENTILADOR", "RADIADOR", "SISTEMA DE INYECCION", "TAPON DE ACEITE", "TAPON RADIADOR", "MOTOR",
                    "DEPOSITO DE AGUA", "ENCENDIDO ELECT.", "FILTRO DE AIRE", "FILTRO GASOLINA", "MARCHA",
                    "MOTOR LIMPIADORES", "BOMBA DE AGUA", "BOMBA DREC. HIDRAU", "BOSTER DE FRENOS", "CABLES BUJIAS",
                    "COMPRESORA AIRE.", "COMPUTADORA", "ALTERBADOR", "BAYONETA DE MOTOR", "BAYONETA  TRANS.", "BOBINA",
                    "BOCINAS DE CLAXON"
                })

                BindSection(rptFrente, "frente", New String() {
                    "FASCIA DEL.", "EMBLEMAS", "FAROS", "FAROS DE NIEBLA", "PARABRISAS", "PARILLA", "FRENTE",
                    "COFRE", "LIMPIADORES", "PLUMAS"
                })

                BindSection(rptIzq, "izq", New String() {
                    "SALPICADERA", "EMBLEMAS", "CRIST. DE COSTADO", "COSTADO", "MOLDURAS", "ESTRIBO", "TAPONES RUEDA",
                    "MANIJAS EXTERIORES", "CRISTAL PTA. DEL.", "CRISTAL PTA. TRA", "PUERTA DEL.", "PUERTA TRA.", "ESPEJOS EXTERIORES"
                })

                BindSection(rptDer, "der", New String() {
                    "SALPICADERA", "EMBLEMAS", "CRISTAL DE COSTADO", "COSTADO", "MOLDURAS", "ESTRIBO", "TAPONES RUEDA",
                    "MANIJAS EXTERIORES", "CRISTAL PTA. DEL.", "CRISTAL PTA. TRA", "PUERTA DEL.", "PUERTA TRA.", "ESPEJOS EXTERIORES"
                })

                BindSection(rptTrasera, "tras", New String() {
                    "MEDALLON", "MOLDURAS", "PORTA PLACAS", "SPOILER", "LAMPARA STOP", "FASCIA TRASERA",
                    "EMBLEMA CAJUELA", "TAPA CAJUELA", "LIMPIADORES"
                })

                BindSection(rptAccesorios, "acc", New String() {
                    "TUMBA BURROS", "TOLDO", "CANASTILLA", "ALARMA", "TAPON GASOLINA", "QUEMACOCOS",
                    "ESTEREO", "ANTENA", "PORTA PLACA"
                })

                BindSection(rptInterior, "int", New String() {
                    "BOTONES ESTEREO", "CABECERAS", "SEGUROS", "INTERIOR", "ALFOMBRA", "ASIENTOS DEL.",
                    "ASIENTOS TRA.", "BOCINA RADIO", "BOTONES DE PTA.", "TACOMETRO", "RELOJ", "TABLERO",
                    "TAPETES", "VISERAS", "GUANTERA", "CENICERO", "CINTURONES", "CODERAS", "CONSOLA",
                    "ENCENDEDOR", "ESPEJO RETROVISOR", "LUZ INTERIOR", "MANIJAS INTERIORES",
                    "AIRE ACONDICIONADO", "CALEFACCION", "VIDRIOS ELECTRICOS"
                })
            End If
        End Sub

        Private Sub BindSection(rep As Repeater, prefix As String, labels As String())
            Dim data As New List(Of Campo)
            For Each lbl In labels
                Dim key As String = prefix & "_" & Slug(lbl)
                data.Add(New Campo With {.Key = key, .Label = lbl})
            Next
            rep.DataSource = data
            rep.DataBind()
        End Sub

        Private Function Slug(text As String) As String
            If String.IsNullOrEmpty(text) Then Return ""
            Dim s = text.ToUpperInvariant()
            s = s.Replace(" ", "_").Replace(".", "").Replace("/", "_").Replace("-", "_").Replace("Ñ", "N")
            s = s.Replace("Á", "A").Replace("É", "E").Replace("Í", "I").Replace("Ó", "O").Replace("Ú", "U")
            s = s.Replace("Ü", "U")
            Return s
        End Function

    End Class

