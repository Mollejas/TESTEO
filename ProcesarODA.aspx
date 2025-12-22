<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="ProcesarODA.aspx.vb" Inherits="TEST1.ProcesarODA" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Procesador de Órdenes de Admisión - Quálitas</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #d32f2f;
            border-bottom: 3px solid #d32f2f;
            padding-bottom: 10px;
        }
        .upload-section {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }
        .textbox {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .textbox:focus {
            border-color: #d32f2f;
            outline: none;
        }
        .btn {
            background-color: #d32f2f;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
        }
        .btn:hover {
            background-color: #b71c1c;
        }
        .btn-secondary {
            background-color: #757575;
        }
        .btn-secondary:hover {
            background-color: #616161;
        }
        .section-title {
            background-color: #d32f2f;
            color: white;
            padding: 10px;
            margin-top: 20px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        .two-column {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        .full-width {
            grid-column: 1 / -1;
        }
        .mensaje {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>📋 Procesador de Órdenes de Admisión - Quálitas</h1>
            
            <div class="upload-section">
                <h3>Cargar Archivos PDF</h3>
                <asp:FileUpload ID="fuArchivos" runat="server" AllowMultiple="true" accept=".pdf" />
                <br /><br />
                <asp:Button ID="btnProcesar" runat="server" Text="Procesar Archivos" CssClass="btn" OnClick="btnProcesar_Click" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar Formulario" CssClass="btn btn-secondary" OnClick="btnLimpiar_Click" />
            </div>

            <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje" Visible="false"></asp:Label>

            <div class="section-title">
                <h3 style="margin: 0;">Información del Siniestro</h3>
            </div>
            
            <div class="two-column">
                <div class="form-group">
                    <label>Folio Electrónico:</label>
                    <asp:TextBox ID="txtFolioElectronico" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>N°. Folio:</label>
                    <asp:TextBox ID="txtFolio" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>N°. Reporte:</label>
                    <asp:TextBox ID="txtReporte" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>N°. Siniestro:</label>
                    <asp:TextBox ID="txtSiniestro" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>N°. de Póliza:</label>
                    <asp:TextBox ID="txtPoliza" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>N°. de Endoso:</label>
                    <asp:TextBox ID="txtEndoso" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>N°. de Inciso:</label>
                    <asp:TextBox ID="txtInciso" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Fecha:</label>
                    <asp:TextBox ID="txtFecha" runat="server" CssClass="textbox" TextMode="Date"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Hora:</label>
                    <asp:TextBox ID="txtHora" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
            </div>

            <div class="section-title">
                <h3 style="margin: 0;">Datos del Asegurado / Tercero</h3>
            </div>
            
            <div class="form-group">
                <label>Nombre o Razón Social del Cliente:</label>
                <asp:TextBox ID="txtAsegurado" runat="server" CssClass="textbox" placeholder="MIRIAM YASMIN CRAVIOTTO GONZALEZ"></asp:TextBox>
            </div>
            
            <div class="two-column">
                <div class="form-group">
                    <label>Teléfono:</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="textbox" placeholder="56 1173 7039"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>E-mail:</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="textbox" TextMode="Email" placeholder="mcraviotto74@gmail.com"></asp:TextBox>
                </div>
            </div>

            <div class="section-title">
                <h3 style="margin: 0;">Centro de Reparación</h3>
            </div>
            
            <div class="form-group">
                <label>Razón Social del CDR:</label>
                <asp:TextBox ID="txtCDR" runat="server" CssClass="textbox"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label>Domicilio:</label>
                <asp:TextBox ID="txtDomicilio" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="2"></asp:TextBox>
            </div>
            
            <div class="two-column">
                <div class="form-group">
                    <label>Responsable:</label>
                    <asp:TextBox ID="txtResponsable" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Teléfono CDR:</label>
                    <asp:TextBox ID="txtTelefonoCDR" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Cobertura:</label>
                    <asp:TextBox ID="txtCobertura" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
            </div>

            <div class="section-title">
                <h3 style="margin: 0;">Datos del Vehículo</h3>
            </div>
            
            <div class="two-column">
                <div class="form-group">
                    <label>Marca:</label>
                    <asp:TextBox ID="txtMarca" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Tipo:</label>
                    <asp:TextBox ID="txtTipo" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Modelo (Año):</label>
                    <asp:TextBox ID="txtModelo" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Color:</label>
                    <asp:TextBox ID="txtColor" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>N°. de Serie (VIN):</label>
                    <asp:TextBox ID="txtSerie" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Placas:</label>
                    <asp:TextBox ID="txtPlacas" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Transmisión:</label>
                    <asp:TextBox ID="txtTransmision" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Kilometraje:</label>
                    <asp:TextBox ID="txtKilometraje" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
            </div>

            <div class="section-title">
                <h3 style="margin: 0;">Daños y Deducible</h3>
            </div>
            
            <div class="form-group">
                <label>Descripción de Daños a Reparar:</label>
                <asp:TextBox ID="txtDanos" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="3"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label>Descripción de Daños Preexistentes:</label>
                <asp:TextBox ID="txtDanosPreexistentes" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="2"></asp:TextBox>
            </div>
            
            <div class="two-column">
                <div class="form-group">
                    <label>Tipo Deducible:</label>
                    <asp:TextBox ID="txtTipoDeducible" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Porcentaje Deducible:</label>
                    <asp:TextBox ID="txtPorcentajeDeducible" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Suma Asegurada:</label>
                    <asp:TextBox ID="txtSumaAsegurada" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Cantidad Deducible:</label>
                    <asp:TextBox ID="txtCantidadDeducible" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
            </div>

            <div class="section-title">
                <h3 style="margin: 0;">Ajustador y Firmas</h3>
            </div>
            
            <div class="two-column">
                <div class="form-group">
                    <label>Nombre del Ajustador/Abogado:</label>
                    <asp:TextBox ID="txtAjustador" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Clave Ajustador:</label>
                    <asp:TextBox ID="txtClaveAjustador" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
            </div>

            <div class="form-group">
                <label>Observaciones Adicionales:</label>
                <asp:TextBox ID="txtObservaciones" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="3"></asp:TextBox>
            </div>

            <br />
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar Información" CssClass="btn" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnExportar" runat="server" Text="Exportar a Excel" CssClass="btn btn-secondary" OnClick="btnExportar_Click" />
        </div>
    </form>
</body>
</html>