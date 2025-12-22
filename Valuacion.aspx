<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Valuacion.aspx.vb" Inherits="TEST1.Valuacion" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Valuación</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        h2 { margin-top: 30px; }
        .totales { font-weight: bold; margin-top: 8px; }
        .grid { width: 100%; margin-bottom: 20px; }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <asp:FileUpload ID="fuPdf" runat="server" />
    <asp:Button ID="btnProcesar" runat="server" Text="Procesar PDF" />

    <h2>REFACCIONES</h2>
    <asp:GridView ID="gvRefacciones" runat="server" CssClass="grid" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
            <asp:BoundField DataField="Monto" HeaderText="Monto" DataFormatString="{0:C}" />
        </Columns>
    </asp:GridView>
    <asp:Label ID="lblTotRef" runat="server" CssClass="totales" />

    <h2>PINTURA</h2>
    <asp:GridView ID="gvPintura" runat="server" CssClass="grid" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
            <asp:BoundField DataField="Monto" HeaderText="Monto" DataFormatString="{0:C}" />
        </Columns>
    </asp:GridView>
    <asp:Label ID="lblTotPintura" runat="server" CssClass="totales" />

    <h2>MANO DE OBRA HOJALATERIA</h2>
    <asp:GridView ID="gvHojalateria" runat="server" CssClass="grid" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
            <asp:BoundField DataField="Monto" HeaderText="Monto" DataFormatString="{0:C}" />
        </Columns>
    </asp:GridView>
    <asp:Label ID="lblTotHoj" runat="server" CssClass="totales" />

</form>
</body>
</html>