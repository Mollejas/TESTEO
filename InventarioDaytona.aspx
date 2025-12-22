<%@ Page Language="VB"
    AutoEventWireup="false"
    CodeBehind="InventarioDaytona.aspx.vb"
    Inherits="TEST1.InventarioDaytona" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Inventario Daytona Automotriz</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- html2pdf.js (opcional) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js" crossorigin="anonymous"></script>

    <style>
        :root{ --ink:#111; --line:#333; --soft:#f8f9fa; --brand:#0d47a1; }
        body{ background:#f2f2f2; }
        .sheet{ background:#fff; color:var(--ink); width:210mm; min-height:297mm; margin:16px auto; padding:14mm; box-shadow:0 10px 30px rgba(0,0,0,.10); border:1px solid #e5e7eb; }
        .brand-title{ font-weight:700; font-size:1.15rem; letter-spacing:.5px; color:var(--brand); }
        .subtitle{ font-size:.95rem; color:#444; margin-top:2px; }
        .section-title{ background:var(--soft); border:1px solid #e5e7eb; padding:.35rem .6rem; font-weight:600; margin:10px 0 6px 0; }
        .bordered{ border:1px solid #dee2e6; border-radius:6px; padding:.6rem; }
        .tiny{ font-size:.85rem; }
        .table-inv{ width:100%; border-collapse:collapse; }
        .table-inv th, .table-inv td{ border:1px solid var(--line); padding:4px 6px; font-size:.86rem; }
        .table-inv th{ background:#eef2f7; text-align:center; }
        .table-inv td:first-child{ width:55%; }
        .table-inv td.opt{ width:15%; text-align:center; }
        .sign-line{ border-top:1px solid var(--line); height:42px; margin-top:28px; }
        .sign-caption{ font-size:.9rem; text-transform:uppercase; text-align:center; margin-top:6px; }
        .legal{ font-size:.78rem; color:#222; line-height:1.25rem; }
        .controls{ position:sticky; top:0; z-index:5; padding:8px; background:#fff; border-bottom:1px solid #eee; }
        @media print{
            body{ background:#fff; }
            .sheet{ box-shadow:none; margin:0; width:auto; min-height:auto; padding:0; }
            .controls{ display:none !important; }
            .table-inv th{ background:#e5e5e5 !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
            @page{ size:A4; margin:10mm; }
        }
        input[type="radio"]{ transform:scale(1.1); }
        .grid-veh .form-control, .grid-veh .form-select{ height: calc(1.4rem + .6rem + 2px); padding:.15rem .5rem; font-size:.9rem; }
        .hdr-box{ display:flex; justify-content:space-between; align-items:center; }
        .hdr-right{ text-align:right; }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Botonera -->
        <div class="controls d-flex gap-2 justify-content-center">
            <button type="button" class="btn btn-primary btn-sm" onclick="window.print()">Imprimir</button>
            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="exportPDF()">Exportar a PDF</button>
        </div>

        <div id="hoja" class="sheet">

            <!-- Encabezado -->
            <div class="hdr-box mb-2">
                <div>
                    <div class="brand-title">INVENTARIO – DAYTONA AUTOMOTRIZ</div>
                    <div class="subtitle">Registro y verificación de estado del vehículo a la recepción</div>
                </div>
                <div class="hdr-right tiny">
                    <div>
                        <strong>Fecha de Expedición:</strong>
                        <asp:TextBox ID="txtFechaExp" runat="server" CssClass="form-control form-control-sm d-inline-block" Style="width: 140px;" TextMode="Date"></asp:TextBox>
                    </div>
                    <div class="mt-1">
                        <strong>No. Expediente</strong>
                        <asp:TextBox ID="txtExp" runat="server" CssClass="form-control form-control-sm d-inline-block" Style="width: 140px;"></asp:TextBox>
                    </div>
                </div>
            </div>

            <!-- Datos del vehículo -->
            <div class="section-title">Datos del vehículo</div>
            <div class="grid-veh bordered">
                <div class="row g-2">
                    <div class="col-6 col-md-3">
                        <label class="form-label tiny mb-1">Marca</label>
                        <asp:TextBox ID="txtMarca" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="col-6 col-md-3">
                        <label class="form-label tiny mb-1">Modelo</label>
                        <asp:TextBox ID="txtModelo" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="col-6 col-md-3">
                        <label class="form-label tiny mb-1">Color</label>
                        <asp:TextBox ID="txtColor" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="col-6 col-md-3">
                        <label class="form-label tiny mb-1">Placas</label>
                        <asp:TextBox ID="txtPlacas" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>

                    <div class="col-12 col-md-4">
                        <label class="form-label tiny mb-1">Nº de Serie (VIN)</label>
                        <asp:TextBox ID="txtSerie" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="col-12 col-md-4">
                        <label class="form-label tiny mb-1">Siniestro</label>
                        <asp:TextBox ID="txtSiniestro" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="col-12 col-md-4">
                        <label class="form-label tiny mb-1">Compañía de Seguros</label>
                        <asp:TextBox ID="txtAseguradora" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>

                    <div class="col-6 col-md-3">
                        <label class="form-label tiny mb-1 d-block">Transmisión</label>
                        <div class="form-check form-check-inline">
                            <asp:RadioButton ID="rbAut" runat="server" GroupName="transm" CssClass="form-check-input" />
                            <label class="form-check-label" for="rbAut">AUT</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <asp:RadioButton ID="rbStd" runat="server" GroupName="transm" CssClass="form-check-input" />
                            <label class="form-check-label" for="rbStd">STD</label>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <label class="form-label tiny mb-1 d-block">Llaves</label>
                        <div class="form-check form-check-inline">
                            <asp:RadioButton ID="rbLlaveSi" runat="server" GroupName="llaves" CssClass="form-check-input" />
                            <label class="form-check-label" for="rbLlaveSi">SI</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <asp:RadioButton ID="rbLlaveNo" runat="server" GroupName="llaves" CssClass="form-check-input" />
                            <label class="form-check-label" for="rbLlaveNo">NO</label>
                        </div>
                    </div>

                    <div class="col-12 col-md-6">
                        <div class="row g-2">
                            <div class="col-6">
                                <label class="form-label tiny mb-1 d-block">Herramienta</label>
                                <div class="form-check form-check-inline">
                                    <asp:RadioButton ID="rbHerrSi" runat="server" GroupName="herr" CssClass="form-check-input" />
                                    <label class="form-check-label" for="rbHerrSi">SI</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <asp:RadioButton ID="rbHerrNo" runat="server" GroupName="herr" CssClass="form-check-input" />
                                    <label class="form-check-label" for="rbHerrNo">NO</label>
                                </div>
                            </div>
                            <div class="col-6">
                                <label class="form-label tiny mb-1 d-block">Llanta de Refacción</label>
                                <div class="form-check form-check-inline">
                                    <asp:RadioButton ID="rbRefaSi" runat="server" GroupName="refa" CssClass="form-check-input" />
                                    <label class="form-check-label" for="rbRefaSi">SI</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <asp:RadioButton ID="rbRefaNo" runat="server" GroupName="refa" CssClass="form-check-input" />
                                    <label class="form-check-label" for="rbRefaNo">NO</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 mt-1">
                        <div class="row g-2">
                            <div class="col-6 col-md-3">
                                <label class="form-label tiny mb-1">Llanta Del. Izq.</label>
                                <asp:DropDownList ID="ddlLDI" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="" Text="--" />
                                    <asp:ListItem Value="SI" Text="SI" />
                                    <asp:ListItem Value="NO" Text="NO" />
                                    <asp:ListItem Value="DAÑOS" Text="DAÑOS" />
                                </asp:DropDownList>
                            </div>
                            <div class="col-6 col-md-3">
                                <label class="form-label tiny mb-1">Llanta Del. Der.</label>
                                <asp:DropDownList ID="ddlLDD" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="" Text="--" />
                                    <asp:ListItem Value="SI" Text="SI" />
                                    <asp:ListItem Value="NO" Text="NO" />
                                    <asp:ListItem Value="DAÑOS" Text="DAÑOS" />
                                </asp:DropDownList>
                            </div>
                            <div class="col-6 col-md-3">
                                <label class="form-label tiny mb-1">Llanta Tras. Izq.</label>
                                <asp:DropDownList ID="ddlLTI" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="" Text="--" />
                                    <asp:ListItem Value="SI" Text="SI" />
                                    <asp:ListItem Value="NO" Text="NO" />
                                    <asp:ListItem Value="DAÑOS" Text="DAÑOS" />
                                </asp:DropDownList>
                            </div>
                            <div class="col-6 col-md-3">
                                <label class="form-label tiny mb-1">Llanta Tras. Der.</label>
                                <asp:DropDownList ID="ddlLTD" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="" Text="--" />
                                    <asp:ListItem Value="SI" Text="SI" />
                                    <asp:ListItem Value="NO" Text="NO" />
                                    <asp:ListItem Value="DAÑOS" Text="DAÑOS" />
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Niveles de líquidos -->
            <div class="section-title mt-2">Niveles de líquidos</div>
            <div class="bordered">
                <table class="table-inv">
                    <thead><tr><th>Concepto</th><th>SI</th><th>NO</th><th>DAÑOS</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptLiquidos" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Label") %></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="SI"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="NO"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="DAÑOS"></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <!-- Motor -->
            <div class="section-title mt-2">Motor</div>
            <div class="bordered">
                <table class="table-inv">
                    <thead><tr><th>Concepto</th><th>SI</th><th>NO</th><th>DAÑOS</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptMotor" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Label") %></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="SI"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="NO"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="DAÑOS"></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <!-- Frente -->
            <div class="section-title mt-2">Frente</div>
            <div class="bordered">
                <table class="table-inv">
                    <thead><tr><th>Concepto</th><th>SI</th><th>NO</th><th>DAÑOS</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptFrente" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Label") %></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="SI"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="NO"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="DAÑOS"></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <!-- Lado Izquierdo -->
            <div class="section-title mt-2">Lado Izquierdo</div>
            <div class="bordered">
                <table class="table-inv">
                    <thead><tr><th>Concepto</th><th>SI</th><th>NO</th><th>DAÑOS</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptIzq" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Label") %></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="SI"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="NO"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="DAÑOS"></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <!-- Lado Derecho -->
            <div class="section-title mt-2">Lado Derecho</div>
            <div class="bordered">
                <table class="table-inv">
                    <thead><tr><th>Concepto</th><th>SI</th><th>NO</th><th>DAÑOS</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptDer" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Label") %></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="SI"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="NO"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="DAÑOS"></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <!-- Trasera -->
            <div class="section-title mt-2">Trasera</div>
            <div class="bordered">
                <table class="table-inv">
                    <thead><tr><th>Concepto</th><th>SI</th><th>NO</th><th>DAÑOS</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptTrasera" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Label") %></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="SI"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="NO"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="DAÑOS"></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <!-- Accesorios / Generales -->
            <div class="section-title mt-2">Accesorios / Generales</div>
            <div class="bordered">
                <table class="table-inv">
                    <thead><tr><th>Concepto</th><th>SI</th><th>NO</th><th>DAÑOS</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptAccesorios" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Label") %></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="SI"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="NO"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="DAÑOS"></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <!-- Interior -->
            <div class="section-title mt-2">Interior</div>
            <div class="bordered">
                <table class="table-inv">
                    <thead><tr><th>Concepto</th><th>SI</th><th>NO</th><th>DAÑOS</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptInterior" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Label") %></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="SI"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="NO"></td>
                                    <td class="opt"><input type="radio" name="<%# Eval("Key") %>" value="DAÑOS"></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>

                <div class="row mt-2">
                    <div class="col-6">
                        <label class="form-label tiny mb-1">Kilometraje</label>
                        <asp:TextBox ID="txtKm" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                    </div>
                    <div class="col-6">
                        <label class="form-label tiny mb-1">Nivel de gasolina</label>
                        <asp:DropDownList ID="ddlGas" runat="server" CssClass="form-select">
                            <asp:ListItem Text="--" Value="" />
                            <asp:ListItem Text="Vacío" Value="Vacio" />
                            <asp:ListItem Text="1/4" Value="1/4" />
                            <asp:ListItem Text="1/2" Value="1/2" />
                            <asp:ListItem Text="3/4" Value="3/4" />
                            <asp:ListItem Text="Lleno" Value="Lleno" />
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <!-- Daños / Observaciones -->
            <div class="row g-2 mt-2">
                <div class="col-12">
                    <div class="section-title">Daños preexistentes</div>
                    <asp:TextBox ID="txtDanos" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control bordered"></asp:TextBox>
                </div>
                <div class="col-12">
                    <div class="section-title">Observaciones y/o comentarios</div>
                    <asp:TextBox ID="txtObs" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control bordered"></asp:TextBox>
                </div>
            </div>

            <!-- Firmas -->
            <div class="row mt-4">
                <div class="col-6">
                    <div class="sign-line"></div>
                    <div class="sign-caption">Nombre y firma CLIENTE</div>
                </div>
                <div class="col-6">
                    <div class="sign-line"></div>
                    <div class="sign-caption">Nombre y firma ASESOR DE SERVICIO</div>
                </div>
            </div>

            <!-- Leyendas -->
            <div class="legal mt-4">
                <p><strong>NOTA:</strong> La empresa por ningún motivo será responsable de los objetos no señalados en este inventario.</p>
                <p>Terminada la preparación y avisado el asegurado o cliente, tiene un plazo de 2 días para recoger la unidad. A partir del 3er día el almacenaje del vehículo causará un cargo a razón de $150.00 (ciento cincuenta pesos 00/100 MN) por día.</p>
                <p>Estimado cliente: hacemos de su conocimiento nuestra exclusión en la responsabilidad por daños en piezas eléctricas y/o mecánicas no derivadas del siniestro.</p>
            </div>

        </div>
    </form>

    <script>
        function exportPDF() {
            const el = document.getElementById('hoja');
            html2pdf().from(el).set({
                margin: 8,
                filename: 'InventarioDaytona.pdf',
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: { scale: 2, useCORS: true },
                jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
            }).save();
        }
    </script>
</body>
</html>
