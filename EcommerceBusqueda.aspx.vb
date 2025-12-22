Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.UI
Imports System.Web.UI.WebControls

Public Class EcommerceBusqueda
    Inherits System.Web.UI.Page

    Private ReadOnly connString As String =
        "Data Source=MOYRUBENS\SQLEXPRESS;Initial Catalog=TEST;Integrated Security=True;TrustServerCertificate=True;Connection Timeout=30;"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Try
                CargarAnios()
                ResetCascada()
                HabilitaFiltrosAdicionales(False)
                ViewState("FirstDone") = False
                ViewState("TsuruMode") = False
                ViewState("TsuruGrupoSel") = "__ALL__" ' seleccionado por defecto
                lblMsg.Text = ""
            Catch ex As Exception
                lblMsg.Text = "Error Page_Load: " & ex.Message
            End Try
        End If
    End Sub

    ' ===== Cascada LIBRO4 =====
    Private Sub CargarAnios()
        Using cn As New SqlConnection(connString)
            Dim sql As String =
"SELECT DISTINCT TRY_CONVERT(int,[Año]) AS Anio
   FROM dbo.LIBRO4
  WHERE TRY_CONVERT(int,[Año]) IS NOT NULL
  ORDER BY Anio DESC;"
            Using cmd As New SqlCommand(sql, cn)
                cn.Open()
                Using rd = cmd.ExecuteReader()
                    ddlAno.Items.Clear()
                    ddlAno.Items.Add(New ListItem("-- Año --", ""))
                    While rd.Read()
                        ddlAno.Items.Add(New ListItem(rd("Anio").ToString(), rd("Anio").ToString()))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Protected Sub ddlAno_SelectedIndexChanged(sender As Object, e As EventArgs)
        Try
            ddlMarca.Items.Clear() : ddlMarca.Items.Add(New ListItem("-- Marca --", "")) : ddlMarca.Enabled = False
            ddlModelo.Items.Clear() : ddlModelo.Items.Add(New ListItem("-- Modelo --", "")) : ddlModelo.Enabled = False
            ddlSubmodelo.Items.Clear() : ddlSubmodelo.Items.Add(New ListItem("-- Submodelo --", "")) : ddlSubmodelo.Enabled = False
            ddlMotor.Items.Clear() : ddlMotor.Items.Add(New ListItem("-- Motor --", "")) : ddlMotor.Enabled = False
            pnlGrupoTsuru.Visible = False : ViewState("TsuruMode") = False : upLeft.Update()

            Dim anio = If(ddlAno.SelectedValue, "").Trim()
            If anio = "" Then Exit Sub

            Using cn As New SqlConnection(connString)
                Dim sql As String =
"SELECT DISTINCT MARCA
   FROM dbo.LIBRO4
  WHERE [Año]=@anio AND NULLIF(LTRIM(RTRIM(MARCA)),'') IS NOT NULL
  ORDER BY MARCA;"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@anio", anio)
                    cn.Open()
                    Using rd = cmd.ExecuteReader()
                        While rd.Read()
                            ddlMarca.Items.Add(New ListItem(rd("MARCA").ToString(), rd("MARCA").ToString()))
                        End While
                    End Using
                End Using
            End Using
            ddlMarca.Enabled = True
            lblMsg.Text = ""
        Catch ex As Exception
            lblMsg.Text = "Error Año: " & ex.Message
        End Try
    End Sub

    Protected Sub ddlMarca_SelectedIndexChanged(sender As Object, e As EventArgs)
        Try
            ddlModelo.Items.Clear() : ddlModelo.Items.Add(New ListItem("-- Modelo --", "")) : ddlModelo.Enabled = False
            ddlSubmodelo.Items.Clear() : ddlSubmodelo.Items.Add(New ListItem("-- Submodelo --", "")) : ddlSubmodelo.Enabled = False
            ddlMotor.Items.Clear() : ddlMotor.Items.Add(New ListItem("-- Motor --", "")) : ddlMotor.Enabled = False
            pnlGrupoTsuru.Visible = False : ViewState("TsuruMode") = False : upLeft.Update()

            Dim anio = If(ddlAno.SelectedValue, "").Trim()
            Dim marca = If(ddlMarca.SelectedValue, "").Trim()
            If anio = "" OrElse marca = "" Then Exit Sub

            Using cn As New SqlConnection(connString)
                Dim sql As String =
"SELECT DISTINCT MODELO
   FROM dbo.LIBRO4
  WHERE [Año]=@anio AND MARCA=@marca
    AND NULLIF(LTRIM(RTRIM(MODELO)),'') IS NOT NULL
  ORDER BY MODELO;"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@anio", anio)
                    cmd.Parameters.AddWithValue("@marca", marca)
                    cn.Open()
                    Using rd = cmd.ExecuteReader()
                        While rd.Read()
                            ddlModelo.Items.Add(New ListItem(rd("MODELO").ToString(), rd("MODELO").ToString()))
                        End While
                    End Using
                End Using
            End Using
            ddlModelo.Enabled = True
            lblMsg.Text = ""
        Catch ex As Exception
            lblMsg.Text = "Error Marca: " & ex.Message
        End Try
    End Sub

    Protected Sub ddlModelo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Try
            ddlSubmodelo.Items.Clear() : ddlSubmodelo.Items.Add(New ListItem("-- Submodelo --", "")) : ddlSubmodelo.Enabled = False
            ddlMotor.Items.Clear() : ddlMotor.Items.Add(New ListItem("-- Motor --", "")) : ddlMotor.Enabled = False
            pnlGrupoTsuru.Visible = False : ViewState("TsuruMode") = False : upLeft.Update()

            Dim anio = If(ddlAno.SelectedValue, "").Trim()
            Dim marca = If(ddlMarca.SelectedValue, "").Trim()
            Dim modelo = If(ddlModelo.SelectedValue, "").Trim()
            If anio = "" OrElse marca = "" OrElse modelo = "" Then Exit Sub

            Using cn As New SqlConnection(connString)
                Dim sql As String =
"SELECT DISTINCT SUBMODELO
   FROM dbo.LIBRO4
  WHERE [Año]=@anio AND MARCA=@marca AND MODELO=@modelo
    AND NULLIF(LTRIM(RTRIM(SUBMODELO)),'') IS NOT NULL
  ORDER BY SUBMODELO;"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@anio", anio)
                    cmd.Parameters.AddWithValue("@marca", marca)
                    cmd.Parameters.AddWithValue("@modelo", modelo)
                    cn.Open()
                    Using rd As SqlDataReader = cmd.ExecuteReader()
                        While rd.Read()
                            ddlSubmodelo.Items.Add(New ListItem(rd("SUBMODELO").ToString(), rd("SUBMODELO").ToString()))
                        End While
                    End Using
                End Using
            End Using
            ddlSubmodelo.Enabled = True
            lblMsg.Text = ""
        Catch ex As Exception
            lblMsg.Text = "Error Modelo: " & ex.Message
        End Try
    End Sub

    Protected Sub ddlSubmodelo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Try
            ddlMotor.Items.Clear() : ddlMotor.Items.Add(New ListItem("-- Motor --", "")) : ddlMotor.Enabled = False
            pnlGrupoTsuru.Visible = False : ViewState("TsuruMode") = False : upLeft.Update()

            Dim anio = If(ddlAno.SelectedValue, "").Trim()
            Dim marca = If(ddlMarca.SelectedValue, "").Trim()
            Dim modelo = If(ddlModelo.SelectedValue, "").Trim()
            Dim submodelo = If(ddlSubmodelo.SelectedValue, "").Trim()
            If anio = "" OrElse marca = "" OrElse modelo = "" OrElse submodelo = "" Then Exit Sub

            Using cn As New SqlConnection(connString)
                Dim sql As String =
"SELECT DISTINCT MOTOR_L
   FROM dbo.LIBRO4
  WHERE [Año]=@anio AND MARCA=@marca AND MODELO=@modelo AND SUBMODELO=@submodelo
    AND NULLIF(LTRIM(RTRIM(MOTOR_L)),'') IS NOT NULL
  ORDER BY MOTOR_L;"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@anio", anio)
                    cmd.Parameters.AddWithValue("@marca", marca)
                    cmd.Parameters.AddWithValue("@modelo", modelo)
                    cmd.Parameters.AddWithValue("@submodelo", submodelo)
                    cn.Open()
                    Using rd As SqlDataReader = cmd.ExecuteReader()
                        While rd.Read()
                            ddlMotor.Items.Add(New ListItem(rd("MOTOR_L").ToString(), rd("MOTOR_L").ToString()))
                        End While
                    End Using
                End Using
            End Using
            ddlMotor.Enabled = True
            lblMsg.Text = ""
        Catch ex As Exception
            lblMsg.Text = "Error Submodelo: " & ex.Message
        End Try
    End Sub

    Private Sub ResetCascada()
        ddlMarca.Items.Clear() : ddlMarca.Items.Add(New ListItem("-- Marca --", "")) : ddlMarca.Enabled = False
        ddlModelo.Items.Clear() : ddlModelo.Items.Add(New ListItem("-- Modelo --", "")) : ddlModelo.Enabled = False
        ddlSubmodelo.Items.Clear() : ddlSubmodelo.Items.Add(New ListItem("-- Submodelo --", "")) : ddlSubmodelo.Enabled = False
        ddlMotor.Items.Clear() : ddlMotor.Items.Add(New ListItem("-- Motor --", "")) : ddlMotor.Enabled = False
        pnlGrupoTsuru.Visible = False : ViewState("TsuruMode") = False
    End Sub

    ' ===== Botones =====
    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        Try
            ViewState("TsuruMode") = False
            pnlGrupoTsuru.Visible = False
            upLeft.Update()

            Dim firstDone As Boolean = Convert.ToBoolean(ViewState("FirstDone"))
            If Not firstDone Then
                BuscarPrimeraVez()
                ViewState("FirstDone") = True
            Else
                BuscarSoloMarcaModelo(refinando:=False)
            End If
        Catch ex As Exception
            lblMsg.Text = "Error buscar: " & ex.Message
        End Try
    End Sub

    Protected Sub btnRefinar_Click(sender As Object, e As EventArgs)
        Try
            ViewState("TsuruMode") = False
            pnlGrupoTsuru.Visible = False
            upLeft.Update()
            BuscarSoloMarcaModelo(refinando:=True)
        Catch ex As Exception
            lblMsg.Text = "Error refinar: " & ex.Message
        End Try
    End Sub

    Protected Sub btnLimpiarFiltros_Click(sender As Object, e As EventArgs)
        Try
            ViewState("TsuruMode") = False
            pnlGrupoTsuru.Visible = False
            upLeft.Update()
            chkGrupo.ClearSelection()
            chkTipo.ClearSelection()
            BuscarSoloMarcaModelo(refinando:=True)
        Catch ex As Exception
            lblMsg.Text = "Error limpiar filtros: " & ex.Message
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
        Try
            ddlAno.SelectedIndex = 0
            ResetCascada()
            lblCount.Text = "0"
            lblCriteria.Text = ""
            lblMsg.Text = ""
            rptResultados.DataSource = Nothing
            rptResultados.DataBind()
            pnlEmpty.Visible = False
            HabilitaFiltrosAdicionales(False)
            ViewState("FirstDone") = False
            upLeft.Update()
        Catch ex As Exception
            lblMsg.Text = "Error limpiar: " & ex.Message
        End Try
    End Sub

    ' ===== TSURU =====
    Protected Sub btnTsuru_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As DataTable = QueryTsuruTop20()
            BindResultados(dt)
            lblCriteria.Text = "TSURU · Top 20 (descripcion contiene 'tsuru')"
            lblMsg.Text = If(dt.Rows.Count = 0, "No se encontraron artículos para 'tsuru'.", "Búsqueda TSURU completada.")
            ViewState("TsuruMode") = True

            CargarListaGruposTsuru()
            pnlGrupoTsuru.Visible = True
            ViewState("TsuruGrupoSel") = "__ALL__"
            upLeft.Update()
            MarcarGrupoTsuruSeleccionado("__ALL__")
        Catch ex As Exception
            lblMsg.Text = "Error TSURU: " & ex.Message
            pnlEmpty.Visible = True
        End Try
    End Sub

    Protected Sub bltGrupoTsuru_Click(sender As Object, e As BulletedListEventArgs)
        Try
            Dim grupo As String = bltGrupoTsuru.Items(e.Index).Value
            Dim dt As DataTable
            If grupo = "__ALL__" Then
                dt = QueryTsuruTop20()
                lblCriteria.Text = "TSURU · Todos"
            Else
                dt = QueryTsuruPorGrupo(grupo)
                lblCriteria.Text = "TSURU · Grupo: " & grupo
            End If

            BindResultados(dt)
            lblMsg.Text = If(dt.Rows.Count = 0, "Sin resultados para la selección.", "Filtrado aplicado.")
            ViewState("TsuruMode") = True
            ViewState("TsuruGrupoSel") = grupo
            pnlGrupoTsuru.Visible = True
            upLeft.Update()
            MarcarGrupoTsuruSeleccionado(grupo)
        Catch ex As Exception
            lblMsg.Text = "Error al filtrar por grupo: " & ex.Message
        End Try
    End Sub

    ' ===== Primera búsqueda / Subsecuentes =====
    Private Sub BuscarPrimeraVez()
        Dim anio = If(ddlAno.SelectedValue, "").Trim()
        Dim marca = If(ddlMarca.SelectedValue, "").Trim()
        Dim modelo = If(ddlModelo.SelectedValue, "").Trim()
        Dim submodelo = If(ddlSubmodelo.SelectedValue, "").Trim()
        Dim motor = If(ddlMotor.SelectedValue, "").Trim()

        If anio = "" OrElse marca = "" OrElse modelo = "" Then
            lblMsg.Text = "Selecciona al menos AÑO, MARCA y MODELO."
            pnlEmpty.Visible = True
            rptResultados.DataSource = Nothing : rptResultados.DataBind()
            lblCount.Text = "0"
            Exit Sub
        End If

        lblCriteria.Text = $"PRIMERA · AÑO:{anio} · MARCA:{marca} · MODELO:{modelo}" &
                           If(submodelo <> "", $" · SUBMODELO:{submodelo}", "") &
                           If(motor <> "", $" · MOTOR:{motor}", "")

        Dim dt As DataTable = BuscarEnLibro1_TODO(marca, modelo, anio, submodelo, motor)
        BindResultados(dt)

        If dt.Rows.Count = 0 Then
            NotificarSinResultados($"para AÑO:{anio} · MARCA:{marca} · MODELO:{modelo}" &
                                   If(submodelo <> "", $" · SUBMODELO:{submodelo}", "") &
                                   If(motor <> "", $" · MOTOR:{motor}", ""))
        Else
            pnlEmpty.Visible = False
            lblMsg.Text = "Búsqueda inicial completada."
        End If

        CargarFiltrosAdicionales(marca, modelo)
        HabilitaFiltrosAdicionales(True)
    End Sub

    Private Sub BuscarSoloMarcaModelo(refinando As Boolean)
        Dim marca = If(ddlMarca.SelectedValue, "").Trim()
        Dim modelo = If(ddlModelo.SelectedValue, "").Trim()

        If marca = "" OrElse modelo = "" Then
            lblMsg.Text = "Elige MARCA y MODELO."
            pnlEmpty.Visible = True
            rptResultados.DataSource = Nothing : rptResultados.DataBind()
            lblCount.Text = "0"
            Exit Sub
        End If

        lblCriteria.Text = $"MARCA+MODELO · MARCA:{marca} · MODELO:{modelo}"

        Dim grupos = GetSeleccion(chkGrupo)
        Dim tipos = GetSeleccion(chkTipo)
        Dim dt As DataTable = BuscarEnLibro1_MarcaModelo(marca, modelo, grupos, tipos)
        BindResultados(dt)

        Dim filtrosDesc As String = ""
        If grupos IsNot Nothing AndAlso grupos.Count > 0 Then filtrosDesc &= " · GRUPO: " & String.Join("/", grupos)
        If tipos IsNot Nothing AndAlso tipos.Count > 0 Then filtrosDesc &= " · TIPO: " & String.Join("/", tipos)

        If dt.Rows.Count = 0 Then
            NotificarSinResultados($"para MARCA:{marca} · MODELO:{modelo}{filtrosDesc}")
        Else
            pnlEmpty.Visible = False
            lblMsg.Text = If(refinando, "Resultados refinados.", "Búsqueda por marca/modelo completada.")
        End If

        ' al salir de TSURU, limpiamos selección visual
        pnlGrupoTsuru.Visible = False : ViewState("TsuruMode") = False : upLeft.Update()
    End Sub

    ' ===== Queries =====
    Private Function BuscarEnLibro1_TODO(marca As String, modelo As String, anio As String, submodelo As String, motor As String) As DataTable
        Using cn As New SqlConnection(connString)
            cn.Open()
            Dim sql As String =
"SELECT TOP 300 artclave, descripcion, precio, grupodesc, tipodesc
   FROM dbo.LIBRO1 WITH (NOLOCK)
  WHERE (@marca=''  OR descripcion COLLATE Latin1_General_CI_AI LIKE @marcaLike)
    AND (@modelo='' OR descripcion COLLATE Latin1_General_CI_AI LIKE @modeloLike)
    AND (@anio=''   OR descripcion COLLATE Latin1_General_CI_AI LIKE @anioLike)
    AND (@subm=''   OR descripcion COLLATE Latin1_General_CI_AI LIKE @submLike)
    AND (@motor=''  OR descripcion COLLATE Latin1_General_CI_AI LIKE @motorLike)
  ORDER BY precio DESC, artclave;"
            Using cmd As New SqlCommand(sql, cn)
                cmd.Parameters.AddWithValue("@marca", If(marca, ""))
                cmd.Parameters.AddWithValue("@modelo", If(modelo, ""))
                cmd.Parameters.AddWithValue("@anio", If(anio, ""))
                cmd.Parameters.AddWithValue("@subm", If(submodelo, ""))
                cmd.Parameters.AddWithValue("@motor", If(motor, ""))

                cmd.Parameters.AddWithValue("@marcaLike", "%" & marca & "%")
                cmd.Parameters.AddWithValue("@modeloLike", "%" & modelo & "%")
                cmd.Parameters.AddWithValue("@anioLike", "%" & anio & "%")
                cmd.Parameters.AddWithValue("@submLike", "%" & submodelo & "%")
                cmd.Parameters.AddWithValue("@motorLike", "%" & motor & "%")

                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    Return dt
                End Using
            End Using
        End Using
    End Function

    Private Function BuscarEnLibro1_MarcaModelo(marca As String, modelo As String,
                                                grupos As List(Of String), tipos As List(Of String)) As DataTable
        Using cn As New SqlConnection(connString)
            cn.Open()
            Dim sql As String =
"SELECT TOP 300 artclave, descripcion, precio, grupodesc, tipodesc
   FROM dbo.LIBRO1 WITH (NOLOCK)
  WHERE descripcion COLLATE Latin1_General_CI_AI LIKE @marcaLike
    AND descripcion COLLATE Latin1_General_CI_AI LIKE @modeloLike
    /**GRUPOS**/
    /**TIPOS**/
  ORDER BY precio DESC, artclave;"

            Dim gruposSql As String = ""
            If grupos IsNot Nothing AndAlso grupos.Count > 0 Then
                Dim inParams As New List(Of String)()
                For i = 0 To grupos.Count - 1 : inParams.Add($"@g{i}") : Next
                gruposSql = $" AND grupodesc IN ({String.Join(",", inParams)})"
                sql = sql.Replace("/**GRUPOS**/", gruposSql)
            Else
                sql = sql.Replace("/**GRUPOS**/", "")
            End If

            Dim tiposSql As String = ""
            If tipos IsNot Nothing AndAlso tipos.Count > 0 Then
                Dim inParams As New List(Of String)()
                For i = 0 To tipos.Count - 1 : inParams.Add($"@t{i}") : Next
                tiposSql = $" AND tipodesc IN ({String.Join(",", inParams)})"
                sql = sql.Replace("/**TIPOS**/", tiposSql)
            Else
                sql = sql.Replace("/**TIPOS**/", "")
            End If

            Using cmd As New SqlCommand(sql, cn)
                cmd.Parameters.AddWithValue("@marcaLike", "%" & marca & "%")
                cmd.Parameters.AddWithValue("@modeloLike", "%" & modelo & "%")

                If gruposSql <> "" Then
                    For i = 0 To grupos.Count - 1
                        cmd.Parameters.AddWithValue($"@g{i}", grupos(i))
                    Next
                End If
                If tiposSql <> "" Then
                    For i = 0 To tipos.Count - 1
                        cmd.Parameters.AddWithValue($"@t{i}", tipos(i))
                    Next
                End If

                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    Return dt
                End Using
            End Using
        End Using
    End Function

    ' ===== TSURU helpers =====
    Private Function QueryTsuruTop20() As DataTable
        Using cn As New SqlConnection(connString)
            cn.Open()
            Dim sql As String =
"SELECT TOP 20 artclave, descripcion, precio, grupodesc, tipodesc
   FROM dbo.LIBRO1 WITH (NOLOCK)
  WHERE descripcion COLLATE Latin1_General_CI_AI LIKE @q
  ORDER BY precio DESC, artclave;"
            Using cmd As New SqlCommand(sql, cn)
                cmd.Parameters.AddWithValue("@q", "%tsuru%")
                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    Return dt
                End Using
            End Using
        End Using
    End Function

    Private Function QueryTsuruPorGrupo(grupo As String) As DataTable
        Using cn As New SqlConnection(connString)
            cn.Open()
            Dim sql As String =
"SELECT TOP 20 artclave, descripcion, precio, grupodesc, tipodesc
   FROM dbo.LIBRO1 WITH (NOLOCK)
  WHERE descripcion COLLATE Latin1_General_CI_AI LIKE @q
    AND grupodesc = @g
  ORDER BY precio DESC, artclave;"
            Using cmd As New SqlCommand(sql, cn)
                cmd.Parameters.AddWithValue("@q", "%tsuru%")
                cmd.Parameters.AddWithValue("@g", grupo)
                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    Return dt
                End Using
            End Using
        End Using
    End Function

    Private Sub CargarListaGruposTsuru()
        Using cn As New SqlConnection(connString)
            cn.Open()
            Dim sql As String =
"SELECT DISTINCT grupodesc
   FROM dbo.LIBRO1 WITH (NOLOCK)
  WHERE descripcion COLLATE Latin1_General_CI_AI LIKE @q
    AND NULLIF(LTRIM(RTRIM(grupodesc)),'') IS NOT NULL
  ORDER BY grupodesc;"
            Using cmd As New SqlCommand(sql, cn)
                cmd.Parameters.AddWithValue("@q", "%tsuru%")
                Using rd As SqlDataReader = cmd.ExecuteReader()
                    bltGrupoTsuru.Items.Clear()
                    ' ⬅️ Agregamos "Todos" al inicio
                    bltGrupoTsuru.Items.Add(New ListItem("Todos", "__ALL__"))
                    While rd.Read()
                        Dim g As String = Convert.ToString(rd("grupodesc"))
                        bltGrupoTsuru.Items.Add(New ListItem(g, g))
                    End While
                End Using
            End Using
        End Using
    End Sub

    ' Marca visualmente el item seleccionado en la lista (a.active-tsuru)
    Private Sub MarcarGrupoTsuruSeleccionado(selValue As String)
        Dim idx As Integer = 0
        For i = 0 To bltGrupoTsuru.Items.Count - 1
            If bltGrupoTsuru.Items(i).Value = selValue Then
                idx = i : Exit For
            End If
        Next
        Dim js As String =
$"(function(){{
   var ul=document.getElementById('{bltGrupoTsuru.ClientID}');
   if(!ul) return;
   var links=ul.getElementsByTagName('a');
   for(var i=0;i<links.length;i++) links[i].classList.remove('active-tsuru');
   if(links[{idx}]) links[{idx}].classList.add('active-tsuru');
}})();"
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "markTsuruSel", js, True)
    End Sub

    Private Sub BindResultados(dt As DataTable)
        If Not dt.Columns.Contains("ImgUrl") Then dt.Columns.Add("ImgUrl", GetType(String))
        For Each r As DataRow In dt.Rows
            r("ImgUrl") = ResolverImagen(Convert.ToString(r("artclave")).Trim())
        Next
        rptResultados.DataSource = dt
        rptResultados.DataBind()
        lblCount.Text = dt.Rows.Count.ToString()
        pnlEmpty.Visible = (dt.Rows.Count = 0)
    End Sub

    ' ===== Filtros laterales (normales) =====
    Private Sub CargarFiltrosAdicionales(marca As String, modelo As String)
        Using cn As New SqlConnection(connString)
            cn.Open()
            Using cmd As New SqlCommand(
"SELECT DISTINCT grupodesc
   FROM dbo.LIBRO1 WITH (NOLOCK)
  WHERE descripcion COLLATE Latin1_General_CI_AI LIKE @m
    AND descripcion COLLATE Latin1_General_CI_AI LIKE @d
  ORDER BY grupodesc;", cn)
                cmd.Parameters.AddWithValue("@m", "%" & marca & "%")
                cmd.Parameters.AddWithValue("@d", "%" & modelo & "%")
                Using rd = cmd.ExecuteReader()
                    chkGrupo.Items.Clear()
                    While rd.Read()
                        Dim v = Convert.ToString(rd("grupodesc"))
                        If Not String.IsNullOrWhiteSpace(v) Then chkGrupo.Items.Add(New ListItem(v, v))
                    End While
                End Using
            End Using
            Using cmd As New SqlCommand(
"SELECT DISTINCT tipodesc
   FROM dbo.LIBRO1 WITH (NOLOCK)
  WHERE descripcion COLLATE Latin1_General_CI_AI LIKE @m
    AND descripcion COLLATE Latin1_General_CI_AI LIKE @d
  ORDER BY tipodesc;", cn)
                cmd.Parameters.AddWithValue("@m", "%" & marca & "%")
                cmd.Parameters.AddWithValue("@d", "%" & modelo & "%")
                Using rd = cmd.ExecuteReader()
                    chkTipo.Items.Clear()
                    While rd.Read()
                        Dim v = Convert.ToString(rd("tipodesc"))
                        If Not String.IsNullOrWhiteSpace(v) Then chkTipo.Items.Add(New ListItem(v, v))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub HabilitaFiltrosAdicionales(enabled As Boolean)
        chkGrupo.Enabled = enabled
        chkTipo.Enabled = enabled
        btnRefinar.Enabled = enabled
        btnLimpiarFiltros.Enabled = enabled
    End Sub

    ' ===== Helpers =====
    Private Sub NotificarSinResultados(contexto As String)
        lblMsg.Text = "No se encontraron artículos " & contexto & ". Ajusta los filtros o intenta otra combinación."
        pnlEmpty.Visible = True
    End Sub

    Private Function GetSeleccion(lst As CheckBoxList) As List(Of String)
        Dim xs As New List(Of String)()
        For Each it As ListItem In lst.Items
            If it.Selected Then xs.Add(it.Value)
        Next
        Return xs
    End Function

    Private Function ResolverImagen(artclave As String) As String
        If String.IsNullOrEmpty(artclave) Then Return "images/no-image.png"
        Dim jpgVirt = $"~/images/{artclave}.jpg"
        Dim pngVirt = $"~/images/{artclave}.png"
        Try
            Dim pjpg = Server.MapPath(jpgVirt)
            If File.Exists(pjpg) Then Return ResolveUrl(jpgVirt)
        Catch
        End Try
        Try
            Dim ppng = Server.MapPath(pngVirt)
            If File.Exists(ppng) Then Return ResolveUrl(pngVirt)
        Catch
        End Try
        Return $"images/{artclave}.jpg"
    End Function

End Class
