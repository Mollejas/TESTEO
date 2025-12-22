<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="QUALITAS.aspx.vb" Inherits="TEST1.QUALITAS" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <title>Extractor ODA Quálitas → TextBoxes</title>
    <meta charset="utf-8" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background:#0b1324; color:#e9edf5; }
        .card { background:#121a2f; border:1px solid #1e2a4a; }
        .form-label { font-weight:600; color:#b9c4e3; }
        .section-title { font-size:1.1rem; margin-top:1rem; color:#8fb2ff; border-bottom:1px dashed #2a3b6b; padding-bottom:4px; }
        .small-note { color:#9fb0d9; font-size:.85rem; }
        input[type="text"], textarea { background:#0f172a; border-color:#2a3b6b; color:#e9edf5; }
        .btn-primary { background:#2e5cff; border-color:#2e5cff; }
        .grid-2{ display:grid; grid-template-columns:1fr 1fr; gap:12px; }
        .grid-3{ display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px; }
        .grid-4{ display:grid; grid-template-columns:repeat(4,1fr); gap:12px; }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="container py-4">
        <div class="card shadow-lg">
            <div class="card-body">
                <h1 class="h4 mb-3">ORDEN DE ADMISIÓN AUTOMÓVILES → Extractor</h1>
                <p class="small-note">
                    Sube el PDF de Quálitas y presiona “Extraer”. Los campos se rellenarán automáticamente.
                </p>
                <div class="mb-3">
                    <asp:FileUpload ID="fuPdf" runat="server" CssClass="form-control" />
                </div>
                <div class="mb-3">
                    <asp:Button ID="btnExtraer" runat="server" Text="Extraer" CssClass="btn btn-primary" />
                    <asp:Label ID="lblStatus" runat="server" CssClass="ms-3 small-note"></asp:Label>
                </div>

                <div class="section-title">Identificadores</div>
                <div class="grid-3">
                    <div>
                        <label class="form-label">FOLIO ELECTRÓNICO</label>
                        <asp:TextBox ID="txtFolioElectronico" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">N°. SINIESTRO</label>
                        <asp:TextBox ID="txtNoSiniestro" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">N°. REPORTE</label>
                        <asp:TextBox ID="txtNoReporte" runat="server" CssClass="form-control" />
                    </div>
                </div>

                <div class="section-title">Póliza / Endoso / Inciso / Fecha / Hora</div>
                <div class="grid-4">
                    <div>
                        <label class="form-label">N° DE PÓLIZA</label>
                        <asp:TextBox ID="txtPoliza" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">N° DE ENDOSO</label>
                        <asp:TextBox ID="txtEndoso" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">N° DE INCISO</label>
                        <asp:TextBox ID="txtInciso" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">FECHA</label>
                        <asp:TextBox ID="txtFecha" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="grid-3 mt-2">
                    <div>
                        <label class="form-label">HORA</label>
                        <asp:TextBox ID="txtHora" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">ASEGURADO</label>
                        <asp:TextBox ID="txtAsegurado" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">TERCERO Q</label>
                        <asp:TextBox ID="txtTerceroQ" runat="server" CssClass="form-control" />
                    </div>
                </div>

                <div class="section-title">Contacto / Envío</div>
                <div class="grid-2">
                    <div>
                        <label class="form-label">NOMBRE O RAZÓN SOCIAL DEL CLIENTE</label>
                        <asp:TextBox ID="txtCliente" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">RAZÓN SOCIAL DEL CDR A DONDE SE ENVIARÁ EL VEHÍCULO</label>
                        <asp:TextBox ID="txtRazonCDR" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="grid-3 mt-2">
                    <div>
                        <label class="form-label">TELÉFONO (CLIENTE)</label>
                        <asp:TextBox ID="txtTelCliente" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">E-MAIL (CLIENTE)</label>
                        <asp:TextBox ID="txtEmailCliente" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">RESPONSABLE</label>
                        <asp:TextBox ID="txtResponsable" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="mt-2">
                    <label class="form-label">DOMICILIO / COBERTURA</label>
                    <asp:TextBox ID="txtDomicilioCobertura" runat="server" CssClass="form-control" />
                </div>

                <div class="section-title">Vehículo</div>
                <div class="grid-4">
                    <div>
                        <label class="form-label">MARCA</label>
                        <asp:TextBox ID="txtMarca" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">TIPO</label>
                        <asp:TextBox ID="txtTipo" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">MODELO (AÑO)</label>
                        <asp:TextBox ID="txtModeloAnio" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">KILOMETRAJE</label>
                        <asp:TextBox ID="txtKilometraje" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="grid-4 mt-2">
                    <div>
                        <label class="form-label">COLOR</label>
                        <asp:TextBox ID="txtColor" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">N°. DE SERIE</label>
                        <asp:TextBox ID="txtNoSerie" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">TRANSMISIÓN</label>
                        <asp:TextBox ID="txtTransmision" runat="server" CssClass="form-control" />
                    </div>
                    <div>
                        <label class="form-label">PLACAS</label>
                        <asp:TextBox ID="txtPlacas" runat="server" CssClass="form-control" />
                    </div>
                </div>

                <div class="section-title">Otros</div>
                <div>
                    <label class="form-label">DESCRIPCIÓN DE DAÑOS A REPARAR</label>
                    <asp:TextBox ID="txtDescripcionDanios" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>