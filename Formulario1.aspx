<%@ Page Language="vb"  Async="true" AutoEventWireup="false" CodeBehind="Formulario1.aspx.vb" Inherits="TEST1.Formulario1" %>


<!DOCTYPE html>
<html lang="es">
<head runat="server">
  <meta charset="utf-8" />
    <title>Formulario Inspección</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
   
    <base href="<%= Request.Url.GetLeftPart(UriPartial.Authority) & ResolveUrl("~/") %>" />

    <style>
       
        @media print {
            @page { size: A4; margin: 0; }
            body { margin:10px 0 0 0; zoom:48%; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
            .no-print, button { display:none !important; }
            input { border:none; outline:none; box-shadow:none; background:none; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

    <div class="no-print" style="display:flex; gap:8px; justify-content:center; margin:16px 0;">
        <button type="button" onclick="window.print()">Imprimir (navegador)</button>
       
        <asp:Button ID="btnPdf" runat="server" Text="Guardar en PDF (servidor)"
            OnClick="btnPdf_Click" UseSubmitBehavior="false" OnClientClick="return snapshotForm();" />
    </div>

  
    <div id="formularioPDF">
       
        
            <div class="parte1">
                <table class="form-table">
                    <tr>
                        <td>
                            FECHA:
                            <input type="date" name="" id="" required>
                        </td>
                        <td>
                            ORDEN:
                            <input type="text" required>
                        </td>
                        <td colspan="2" rowspan="3">
                            <div>CIA. ASEGURADORA:</div>
                            <textarea class="input-textarea" rows="4" cols="50" required></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            SINIESTRO:
                            <input type="text" required>
                        </td>
                        <td>
                            AUTO COLOR:
                            <input type="text" required>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            MARCA:
                            <input type="text" required>
                        </td>
                        <td>
                            No. DE SERIE:
                            <input type="text" required>
                        </td>
                    </tr>
                  <tr>
  <td>
    PLACAS:
    <input type="text" required>
  </td>

  <!-- GASOLINA -->
  <td rowspan="3">
    GASOLINA
    <div class="gasolina">
      <div class="tanque"><label>0</label><input type="radio" name="NivelGasolina" required></div>
      <div class="tanque"><label>1/4</label><input type="radio" name="NivelGasolina" required></div>
      <div class="tanque"><label>1/2</label><input type="radio" name="NivelGasolina" required></div>
      <div class="tanque"><label>3/4</label><input type="radio" name="NivelGasolina" required></div>
      <div class="tanque"><label>1</label><input type="radio" name="NivelGasolina" required></div>
    </div>
  </td>

  <!-- LLAVES -->
  <td rowspan="3" class="llaves">
    LLAVES
    <div>
      <label>SI <input type="radio" name="llaves" required></label>
      <label>NO <input type="radio" name="llaves" required></label>
    </div>
  </td>

  <!-- TRANSMISIÓN -->
  <td rowspan="3" class="transmision">
    TRANSMISIÓN
    <div>
      <label>STD <input type="radio" name="transmision" required></label>
      <label>AUT. <input type="radio" name="transmision" required></label>
    </div>
  </td>
</tr>
<tr>
  <td>
    KILOMETRAJE:
    <input type="number" required>
  </td>
</tr>
<tr>
  <td><!-- vacío para completar el rowspan --></td>
</tr>

            </table>
            <table>
                <thead>
                    <tr class="espacio"></tr>
                    <tr>
                        <th colspan="4">MOTOR</th>
                        <th colspan="1">SI</th>
                        <th colspan="1">NO</th>
                        <th colspan="1">DAÑOS</th>
                        <th colspan="4">INTERIOR</th>
                        <th colspan="1">SI</th>
                        <th colspan="1">NO</th>
                        <th colspan="1">DAÑOS</th>
                        <th colspan="4">LADO DERECHO</th>
                        <th colspan="1">SI</th>
                        <th colspan="1">NO</th>
                        <th colspan="1">DAÑOS</th>
                        <th colspan="4">FRENTE</th>
                        <th colspan="1">SI</th>
                        <th colspan="1">NO</th>
                        <th colspan="1">DAÑOS</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="4">ALTERNADOR</td>
                        <th colspan="1"><input type="radio" name="alternador" id="" required></th>
                        <th colspan="1"><input type="radio" name="alternador" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="alternador_dano" id=""></th>
                        <td colspan="4">CAJUELA DE GUANTES</td>
                        <th colspan="1"><input type="radio" name="CajuelaGuantes" id="" required></th>
                        <th colspan="1"><input type="radio" name="CajuelaGuantes" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CajuelaGuantes_dano" id=""></th>
                        <td colspan="4">CRISTAL PUERTA TRASERA</td>
                        <th colspan="1"><input type="radio" name="CristalPTraseraD" id="" required></th>
                        <th colspan="1"><input type="radio" name="CristalPTraseraD" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CristalPTraseraD_dano" id=""></th>
                        <td colspan="4">FACIA DELANTERA</td>
                        <th colspan="1"><input type="radio" name="FaciaDelantera" id="" required></th>
                        <th colspan="1"><input type="radio" name="FaciaDelantera" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="FaciaDelantera_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">BANDAS DE FRENO</td>
                        <th colspan="1"><input type="radio" name="BandasFreno" id="" required></th>
                        <th colspan="1"><input type="radio" name="BandasFreno" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="BandasFreno_dano" id=""></th>
                        <td colspan="4">CENICERO</td>
                        <th colspan="1"><input type="radio" name="Cenicero" id="" required></th>
                        <th colspan="1"><input type="radio" name="Cenicero" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Cenicero_dano" id=""></th>
                        <td colspan="4">ESTEREO</td>
                        <th colspan="1"><input type="radio" name="Estereo" id="" required></th>
                        <th colspan="1"><input type="radio" name="Estereo" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Estereo_dano" id=""></th>
                        <td colspan="4">FAROS DE NIEBLA</td>
                        <th colspan="1"><input type="radio" name="FarosNiebla" id="" required></th>
                        <th colspan="1"><input type="radio" name="FarosNiebla" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="FarosNiebla_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">BAYONETA ACEITE MOTOR</td>
                        <th colspan="1"><input type="radio" name="Bayoneta_AceiteMotor" id="" required></th>
                        <th colspan="1"><input type="radio" name="Bayoneta_AceiteMotor" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Bayoneta_AceiteMotor_dano" id=""></th>
                        <td colspan="4">CINTURONES DE SEGURIDAD</td>
                        <th colspan="1"><input type="radio" name="CinturonesSeguridad" id="" required></th>
                        <th colspan="1"><input type="radio" name="CinturonesSeguridad" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CinturonesSeguridad_dano" id=""></th>
                        <td colspan="4">EMBLEMAS</td>
                        <th colspan="1"><input type="radio" name="EmblemasDerecho" id="" required></th>
                        <th colspan="1"><input type="radio" name="EmblemasDerecho" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="EmblemasDerecho_dano" id=""></th>
                        <td colspan="4">FAROS</td>
                        <th colspan="1"><input type="radio" name="Faros" id="" required></th>
                        <th colspan="1"><input type="radio" name="Faros" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Faros_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">BAYONETA ACEITE TRANS.</td>
                        <th colspan="1"><input type="radio" name="Bayoneta_AceiteTrans" id="" required></th>
                        <th colspan="1"><input type="radio" name="Bayoneta_AceiteTrans" id="" required></th>
                        <th colspan="1"><input type="checkbox" name=" Bayoneta_AceiteTrans_dano" id=""></th>
                        <td colspan="4">CODERAS</td>
                        <th colspan="1"><input type="radio" name="Coderas" id="" required></th>
                        <th colspan="1"><input type="radio" name="Coderas" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Coderas_dano" id=""></th>
                        <td colspan="4">ESPEJOS EXTERIORES</td>
                        <th colspan="1"><input type="radio" name="EspejosExterioresDerecho" id="" required></th>
                        <th colspan="1"><input type="radio" name="EspejosExterioresDerecho" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="EspejosExterioresDerecho_dano" id=""></th>
                        <td colspan="4">LUZ XENON</td>
                        <th colspan="1"><input type="radio" name="LuzXenon" id="" required></th>
                        <th colspan="1"><input type="radio" name="LuzXenon" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="LuzXenon_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">BOBINA</td>
                        <th colspan="1"><input type="radio" name="Bobina" id="" required></th>
                        <th colspan="1"><input type="radio" name="Bobina" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Bobina_dano" id=""></th>
                        <td colspan="4">CONSOLA</td>
                        <th colspan="1"><input type="radio" name="Consola" id="" required></th>
                        <th colspan="1"><input type="radio" name="Consola" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Consola_dano" id=""></th>
                        <td colspan="4">MANIJAS EXTERIORES</td>
                        <th colspan="1"><input type="radio" name="ManijasExterioresDerecho" id="" required></th>
                        <th colspan="1"><input type="radio" name="ManijasExterioresDerecho" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="ManijasExterioresDerecho_dano" id=""></th>
                        <td colspan="4">MOLDURAS</td>
                        <th colspan="1"><input type="radio" name="MoldurasFrente" id="" required></th>
                        <th colspan="1"><input type="radio" name="MoldurasFrente" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="MoldurasFrente_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">BOCINAS DE CLAXON</td>
                        <th colspan="1"><input type="radio" name="BocinasClaxon" id="" required></th>
                        <th colspan="1"><input type="radio" name="BocinasClaxon" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="BocinasClaxon_dano" id=""></th>
                        <td colspan="4">CONTROL AIRE ACON.</td>
                        <th colspan="1"><input type="radio" name="ControlAC" id="" required></th>
                        <th colspan="1"><input type="radio" name="ControlAC" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="ControlAC_dano" id=""></th>
                        <td colspan="4">MOLDURAS</td>
                        <th colspan="1"><input type="radio" name="MoldurasDerecha" id="" required></th>
                        <th colspan="1"><input type="radio" name="MoldurasDerecha" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="MoldurasDerecha_dano" id=""></th>
                        <td colspan="4">PARABRISAS</td>
                        <th colspan="1"><input type="radio" name="Parabrisas" id="" required></th>
                        <th colspan="1"><input type="radio" name="Parabrisas" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Parabrisas_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">BOMBA DE AGUA</td>
                        <th colspan="1"><input type="radio" name="Bomba_Agua" id="" required></th>
                        <th colspan="1"><input type="radio" name="Bomba_Agua" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Bomba_Agua_dano" id=""></th>
                        <td colspan="4">CONTROL CALEFACCION</td>
                        <th colspan="1"><input type="radio" name="ControlCalefaccion" id="" required></th>
                        <th colspan="1"><input type="radio" name="ControlCalefaccion" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="ControlCalefaccion_dano" id=""></th>
                        <td colspan="4">PUERTA DELANTERA</td>
                        <th colspan="1"><input type="radio" name="PuertaDelanteraD" id="" required></th>
                        <th colspan="1"><input type="radio" name="PuertaDelanteraD" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="PuertaDelanteraD_dano" id=""></th>
                        <td colspan="4">PARRILLA</td>
                        <th colspan="1"><input type="radio" name="Parrilla" id="" required></th>
                        <th colspan="1"><input type="radio" name="Parrilla" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Parrilla_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">BOMBA DIREC. HIDRAU.</td>
                        <th colspan="1"><input type="radio" name="BombaDirecHidrau" id="" required></th>
                        <th colspan="1"><input type="radio" name="BombaDirecHidrau" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="BombaDirecHidrau_dano" id=""></th>
                        <td colspan="4">VIDRIOS ELECTRICOS</td>
                        <th colspan="1"><input type="radio" name="VidriosElectricos" id="" required></th>
                        <th colspan="1"><input type="radio" name="VidriosElectricos" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="VidriosElectricos_dano" id=""></th>
                        <td colspan="4">PUERTA TRASERA</td>
                        <th colspan="1"><input type="radio" name="PuertaTraserasD" id="" required></th>
                        <th colspan="1"><input type="radio" name="PuertaTraserasD" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="PuertaTraserasD_dano" id=""></th>
                        <td colspan="4">PLUMAS LIMPIADORAS</td>
                        <th colspan="1"><input type="radio" name="PlumasLimpiadoras" id="" required></th>
                        <th colspan="1"><input type="radio" name="PlumasLimpiadoras" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="PlumasLimpiadoras_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">BOSTER DE FRENOS</td>
                        <th colspan="1"><input type="radio" name="BosterFreno" id="" required></th>
                        <th colspan="1"><input type="radio" name="BosterFreno" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="BosterFreno_dano" id=""></th>
                        <td colspan="4">ENCENDEDORES</td>
                        <th colspan="1"><input type="radio" name="Encendedores" id="" required></th>
                        <th colspan="1"><input type="radio" name="Encendedores" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Encendedores_dano" id=""></th>
                        <td colspan="4">CRISTAL DE COSTADO</td>
                        <th colspan="1"><input type="radio" name="CristalCostadoD" id="" required></th>
                        <th colspan="1"><input type="radio" name="CristalCostadoD" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CristalCostadoD_dano" id=""></th>
                        <td colspan="4">PORTA PLACA</td>
                        <th colspan="1"><input type="radio" name="PortaPlacaFrente" id="" required></th>
                        <th colspan="1"><input type="radio" name="PortaPlacaFrente" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="PortaPlacaFrente_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">CABLES BUJIA</td>
                        <th colspan="1"><input type="radio" name="CablesBujias" id="" required></th>
                        <th colspan="1"><input type="radio" name="CablesBujias" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CablesBujias_dano" id=""></th>
                        <td colspan="4">ESPEJO RETROVISOR</td>
                        <th colspan="1"><input type="radio" name="EspejoRetrovisor" id="" required></th>
                        <th colspan="1"><input type="radio" name="EspejoRetrovisor" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="EspejoRetrovisor_dano" id=""></th>
                        <td colspan="4">COSTADO</td>
                        <th colspan="1"><input type="radio" name="CostadoD" id="" required></th>
                        <th colspan="1"><input type="radio" name="CostadoD" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CostadoD_dano" id=""></th>
                        <td colspan="4">SPOILER</td>
                        <th colspan="1"><input type="radio" name="SpoilerFrente" id="" required></th>
                        <th colspan="1"><input type="radio" name="SpoilerFrente" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="SpoilerFrente_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">COMPRESOR AIRE ACON.</td>
                        <th colspan="1"><input type="radio" name="CompresorAC" id="" required></th>
                        <th colspan="1"><input type="radio" name="CompresorAC" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CompresorAC_dano" id=""></th>
                        <td colspan="4">LUZ INTERIOR</td>
                        <th colspan="1"><input type="radio" name="LuzInterior" id="" required></th>
                        <th colspan="1"><input type="radio" name="LuzInterior" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="LuzInterior_dano" id=""></th>
                        <td colspan="4">SALPICADERA</td>
                        <th colspan="1"><input type="radio" name="Salpicadera" id="" required></th>
                        <th colspan="1"><input type="radio" name="Salpicadera" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Salpicadera_dano" id=""></th>
                        <th colspan="4" class="th2">TRASERA</th>
                        <th colspan="1" class="th2">SI</th>
                        <th colspan="1" class="th2">NO</th>
                        <th colspan="1" class="th2">DAÑOS</th>
                    </tr>
                    <tr>
                        <td colspan="4">COMPUTADORA</td>
                        <th colspan="1"><input type="radio" name="Computadora" id="" required></th>
                        <th colspan="1"><input type="radio" name="Computadora" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Computadora_dano" id=""></th>
                        <td colspan="4">MANIJAS INTERIORES</td>
                        <th colspan="1"><input type="radio" name="ManijaInteriores" id="" required></th>
                        <th colspan="1"><input type="radio" name="ManijaInteriores" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="ManijaInteriores_damo" id=""></th>
                        <td colspan="4">TAPONES RUEDA</td>
                        <th colspan="1"><input type="radio" name="TaponesRuedaD" id="" required></th>
                        <th colspan="1"><input type="radio" name="TaponesRuedaD" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="TaponesRuedaD  _dano" id=""></th>
                        <td colspan="4">CALAVERAS</td>
                        <th colspan="1"><input type="radio" name="Calaveras" id="" required></th>
                        <th colspan="1"><input type="radio" name="Calaveras" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Calaveras_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">DEPOSITO DE AGUA LIMPIA</td>
                        <th colspan="1"><input type="radio" name="DepositoAguaLimp" id="" required></th>
                        <th colspan="1"><input type="radio" name="DepositoAguaLimp" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="DepositoAguaLimp_dano" id=""></th>
                        <td colspan="4">PERILLA PALANCA</td>
                        <th colspan="1"><input type="radio" name="PerillaPalanca" id="" required></th>
                        <th colspan="1"><input type="radio" name="PerillaPalanca" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="PerillaPalanca_dano" id=""></th>
                        <th colspan="4" class="th2">LADO IZQUIERDO</th>
                        <th colspan="1" class="th2">SI</th>
                        <th colspan="1" class="th2">NO</th>
                        <th colspan="1" class="th2">DAÑOS</th>
                        <td colspan="4">EMBLEMA CAJUELA</td>
                        <th colspan="1"><input type="radio" name="EmblemaCajuela" id="" required></th>
                        <th colspan="1"><input type="radio" name="EmblemaCajuela" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="EmblemaCajuela_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">ENCENDIDO ELECTRONICO</td>
                        <th colspan="1"><input type="radio" name="EncendidoElectronico" id="" required></th>
                        <th colspan="1"><input type="radio" name="EncendidoElectronico" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="EncendidoElectronico_dano" id=""></th>
                        <td colspan="4">PALANCA DE VELOCIDADES</td>
                        <th colspan="1"><input type="radio" name="PalancaVelocidades" id="" required></th>
                        <th colspan="1"><input type="radio" name="PalancaVelocidades" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="PalancaVelocidades_dano" id=""></th>
                        <td colspan="4">CRISTAL PUERTA DELANTERA</td>
                        <th colspan="1"><input type="radio" name="CristalPuertaDelanteraI" id="" required></th>
                        <th colspan="1"><input type="radio" name="CristalPuertaDelanteraI" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CristalPuertaDelanteraI_dano" id=""></th>
                        <td colspan="4">FACIA TRASERA</td>
                        <th colspan="1"><input type="radio" name="FaciaTrasera" id="" required></th>
                        <th colspan="1"><input type="radio" name="FaciaTrasera" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="FaciaTrasera_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">FILTRO AIRE</td>
                        <th colspan="1"><input type="radio" name="FiltroAire" id="" required></th>
                        <th colspan="1"><input type="radio" name="FiltroAire" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="FiltroAire_dano" id=""></th>
                        <td colspan="4">RELOJ</td>
                        <th colspan="1"><input type="radio" name="Reloj" id="" required></th>
                        <th colspan="1"><input type="radio" name="Reloj" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Reloj_dano" id=""></th>
                        <td colspan="4">CRISTAL PUERTA TRASERA</td>
                        <th colspan="1"><input type="radio" name="CristalPuertaTraseraI" id="" required></th>
                        <th colspan="1"><input type="radio" name="CristalPuertaTraseraI" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CristalPuertaTraseraI_dano" id=""></th>
                        <td colspan="4">LAMPARA STOP</td>
                        <th colspan="1"><input type="radio" name="LamparaStop" id="" required></th>
                        <th colspan="1"><input type="radio" name="LamparaStop" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="LamparaStop_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">FILTRO GASOLINA</td>
                        <th colspan="1"><input type="radio" name="FiltroGasolina" id="" required></th>
                        <th colspan="1"><input type="radio" name="FiltroGasolina" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="FiltroGasolina_dano" id=""></th>
                        <td colspan="4">TABLERO</td>
                        <th colspan="1"><input type="radio" name="Tablero" id="" required></th>
                        <th colspan="1"><input type="radio" name="Tablero" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Tablero_dano" id=""></th>
                        <td colspan="4">ESTRIBO</td>
                        <th colspan="1"><input type="radio" name="Estribo" id="" required></th>
                        <th colspan="1"><input type="radio" name="Estribo" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Estribo_dano" id=""></th>
                        <td colspan="4">LIMPIADORES</td>
                        <th colspan="1"><input type="radio" name="Limpiadores" id="" required></th>
                        <th colspan="1"><input type="radio" name="Limpiadores" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Limpiadores_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">MARCHA</td>
                        <th colspan="1"><input type="radio" name="Marcha" id="" required></th>
                        <th colspan="1"><input type="radio" name="Marcha" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Marcha_dano" id=""></th>
                        <td colspan="4">TAPETES</td>
                        <th colspan="1"><input type="radio" name="Tapetes" id="" required></th>
                        <th colspan="1"><input type="radio" name="Tapetes" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Tapetes_dano" id=""></th>
                        <td colspan="4">EMBLEMAS</td>
                        <th colspan="1"><input type="radio" name="EmblemaIzquierdo" id="" required></th>
                        <th colspan="1"><input type="radio" name="EmblemaIzquierdo" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="EmblemaIzquierdo_dano" id=""></th>
                        <td colspan="4">MEDALLON</td>
                        <th colspan="1"><input type="radio" name="Medallon" id="" required></th>
                        <th colspan="1"><input type="radio" name="Medallon" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Medallon_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">MOTOR LIMPIADORES</td>
                        <th colspan="1"><input type="radio" name="MotorLimpiador" id="" required></th>
                        <th colspan="1"><input type="radio" name="MotorLimpiador" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="MotorLimpiador_dano" id=""></th>
                        <td colspan="4">VISERAS</td>
                        <th colspan="1"><input type="radio" name="Viseras" id="" required></th>
                        <th colspan="1"><input type="radio" name="Viseras" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Viseras_dano" id=""></th>
                        <td colspan="4">ESPEJOS EXTERIORES</td>
                        <th colspan="1"><input type="radio" name="EspejosExterioresIzquierdo" id="" required></th>
                        <th colspan="1"><input type="radio" name="EspejosExterioresIzquierdo" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="EspejosExterioresIzquierdo_dano" id=""></th>
                        <td colspan="4">MOLDURAS</td>
                        <th colspan="1"><input type="radio" name="MoldurasTrasera" id="" required></th>
                        <th colspan="1"><input type="radio" name="MoldurasTrasera" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="MoldurasTrasera_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">MOTOR VENTILADOR</td>
                        <th colspan="1"><input type="radio" name="MotorVentilador" id="" required></th>
                        <th colspan="1"><input type="radio" name="MotorVentilador" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="MotorVentilador_dano" id=""></th>
                        <td colspan="4">CIELO</td>
                        <th colspan="1"><input type="radio" name="Cielo" id="" required></th>
                        <th colspan="1"><input type="radio" name="Cielo" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Cielo_dano" id=""></th>
                        <td colspan="4">MANIJAS EXTERIORES</td>
                        <th colspan="1"><input type="radio" name="ManijasExterioresIzquierdo" id="" required></th>
                        <th colspan="1"><input type="radio" name="ManijasExterioresIzquierdo" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="ManijasExterioresIzquierdo_dano" id=""></th>
                        <td colspan="4">PORTA PLACAS</td>
                        <th colspan="1"><input type="radio" name="PortaPlacaTrasera" id="" required></th>
                        <th colspan="1"><input type="radio" name="PortaPlacaTrasera" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="PortaPlacaTrasera_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">RADIADOR</td>
                        <th colspan="1"><input type="radio" name="Radiador" id="" required></th>
                        <th colspan="1"><input type="radio" name="Radiador" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Radiador_dano" id=""></th>
                        <th colspan="4" class="th2">CAJUELA</th>
                        <th colspan="1" class="th2">SI</th>
                        <th colspan="1" class="th2">NO</th>
                        <th colspan="1" class="th2">DAÑOS</th>
                        <td colspan="4">MOLDURAS</td>
                        <th colspan="1"><input type="radio" name="MolduraIzquierda" id="" required></th>
                        <th colspan="1"><input type="radio" name="MolduraIzquierda" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="MolduraIzquierda_dano" id=""></th>
                        <td colspan="4">SPOILER</td>
                        <th colspan="1"><input type="radio" name="SpoilerTrasero" id="" required></th>
                        <th colspan="1"><input type="radio" name="SpoilerTrasero" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="SpoilerTrasero_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">SISTEMA DE INYECCION</td>
                        <th colspan="1"><input type="radio" name="SistemaInyeccion" id="" required></th>
                        <th colspan="1"><input type="radio" name="SistemaInyeccion" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="SistemaInyeccion_dano" id=""></th>
                        <td colspan="4">CABLES PASA CORRIENTE</td>
                        <th colspan="1"><input type="radio" name="CablePasaCorriente" id="" required></th>
                        <th colspan="1"><input type="radio" name="CablePasaCorriente" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CablePasaCorriente_dano" id=""></th>
                        <td colspan="4">PUERTA DELANTERA</td>
                        <th colspan="1"><input type="radio" name="PuertaDelanteraI" id="" required></th>
                        <th colspan="1"><input type="radio" name="PuertaDelanteraI" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="PuertaDelanteraI_dano" id=""></th>
                        <td colspan="4">TAPA CAJUELA</td>
                        <th colspan="1"><input type="radio" name="TapaCajuela" id="" required></th>
                        <th colspan="1"><input type="radio" name="TapaCajuela" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="TapaCajuela_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">TAPÓN ACEITE MOTOR</td>
                        <th colspan="1"><input type="radio" name="TaponAceiteMotor" id="" required></th>
                        <th colspan="1"><input type="radio" name="TaponAceiteMotor" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="TaponAceiteMotor_dano" id=""></th>
                        <td colspan="4">CARTÓN CAJUELA</td>
                        <th colspan="1"><input type="radio" name="CartonCajuela" id="" required></th>
                        <th colspan="1"><input type="radio" name="CartonCajuela" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CartonCajuela_dano" id=""></th>
                        <td colspan="4">PUERTA TRASERA</td>
                        <th colspan="1"><input type="radio" name="PuertaTraseraI" id="" required></th>
                        <th colspan="1"><input type="radio" name="PuertaTraseraI" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="PuertaTraseraI_dano" id=""></th>
                        <th colspan="4" class="th2">GENERAL</th>
                        <th colspan="1" class="th2">SI</th>
                        <th colspan="1" class="th2">NO</th>
                        <th colspan="1" class="th2">DAÑOS</th>
                    </tr>
                    <tr>
                        <td colspan="4">TAPÓN RADIADOR</td>
                        <th colspan="1"><input type="radio" name="TaponRadiador" id="" required></th>
                        <th colspan="1"><input type="radio" name="TaponRadiador" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="TaponRadiador_dano" id=""></th>
                        <td colspan="4">BIRLO</td>
                        <th colspan="1"><input type="radio" name="Birlo" id="" required></th>
                        <th colspan="1"><input type="radio" name="Birlo" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Birlo_dano" id=""></th>
                        <td colspan="4">CRISTAL DE COSTADO</td>
                        <th colspan="1"><input type="radio" name="CristalCostadoI" id="" required></th>
                        <th colspan="1"><input type="radio" name="CristalCostadoI" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CristalCostadoI_dano" id=""></th>
                        <td colspan="4">TUMBA-BURROS</td>
                        <th colspan="1"><input type="radio" name="TumbaBurros" id="" required></th>
                        <th colspan="1"><input type="radio" name="TumbaBurros" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="TumbaBurros_dano" id=""></th>
                    </tr>
                    <tr>
                        <th colspan="4" class="th2">INTERIOR</th>
                        <th colspan="1" class="th2">SI</th>
                        <th colspan="1" class="th2">NO</th>
                        <th colspan="1" class="th2">DAÑOS</th>
                        <td colspan="4">LUZ DE CAJUELA</td>
                        <th colspan="1"><input type="radio" name="LuzCajuela" id="" required></th>
                        <th colspan="1"><input type="radio" name="LuzCajuela" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="LuzCajuela_dano" id=""></th>
                        <td colspan="4">COSTADO</td>
                        <th colspan="1"><input type="radio" name="CostadoI" id="" required></th>
                        <th colspan="1"><input type="radio" name="CostadoI" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CostadoI_dano" id=""></th>
                        <td colspan="4">TOLDO</td>
                        <th colspan="1"><input type="radio" name="Toldo" id="" required></th>
                        <th colspan="1"><input type="radio" name="Toldo" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Toldo_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">ALFOMBRA</td>
                        <th colspan="1"><input type="radio" name="Alfombra" id="" required></th>
                        <th colspan="1"><input type="radio" name="Alfombra" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Alfombra_dano" id=""></th>
                        <td colspan="4">EXTINGUIDOR</td>
                        <th colspan="1"><input type="radio" name="Extinguidor" id="" required></th>
                        <th colspan="1"><input type="radio" name="Extinguidor" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Extinguidor_dano" id=""></th>
                        <td colspan="4">SALPICADERA</td>
                        <th colspan="1"><input type="radio" name="Salpicadera" id="" required></th>
                        <th colspan="1"><input type="radio" name="Salpicadera" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Salpicadera_dano" id=""></th>
                        <td colspan="4">CANASTILLA</td>
                        <th colspan="1"><input type="radio" name="Canastilla" id="" required></th>
                        <th colspan="1"><input type="radio" name="Canastilla" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Canastilla_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">ASIENTOS DELANTEROS</td>
                        <th colspan="1"><input type="radio" name="AsientosDelanteros" id="" required></th>
                        <th colspan="1"><input type="radio" name="AsientosDelanteros" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="AsientosDelanteros_dano" id=""></th>
                        <td colspan="4">GATO</td>
                        <th colspan="1"><input type="radio" name="Gato" id="" required></th>
                        <th colspan="1"><input type="radio" name="Gato" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Gato_dano" id=""></th>
                        <td colspan="4">TAPONES RUEDA</td>
                        <th colspan="1"><input type="radio" name="TaponesRuedaI" id="" required></th>
                        <th colspan="1"><input type="radio" name="TaponesRuedaI" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="TaponesRuedaI_dano" id=""></th>
                        <td colspan="4">ALARMA</td>
                        <th colspan="1"><input type="radio" name="Alarma" id="" required></th>
                        <th colspan="1"><input type="radio" name="Alarma" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Alarma_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">ASIENTOS TRASEROS</td>
                        <th colspan="1"><input type="radio" name="AsientosTraseros" id="" required></th>
                        <th colspan="1"><input type="radio" name="AsientosTraseros" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="AsientosTraseros_dano" id=""></th>
                        <td colspan="4">HERRAMIENTAS</td>
                        <th colspan="1"><input type="radio" name="Herramientas" id="" required></th>
                        <th colspan="1"><input type="radio" name="Herramientas" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Herramientas_dano" id=""></th>
                        <th colspan="4" class="th2">FRENTE</th>
                        <th colspan="1" class="th2">SI</th>
                        <th colspan="1" class="th2">NO</th>
                        <th colspan="1" class="th2">DAÑOS</th>
                        <td colspan="4">TAPÓN GASOLINA</td>
                        <th colspan="1"><input type="radio" name="TaponGasolina" id="" required></th>
                        <th colspan="1"><input type="radio" name="TaponGasolina" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="TaponGasolina_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">BOCINA RADIO</td>
                        <th colspan="1"><input type="radio" name="BocinaRadio" id="" required></th>
                        <th colspan="1"><input type="radio" name="BocinaRadio" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="BocinaRadio_dano" id=""></th>
                        <td colspan="4">LLAVE RUEDA</td>
                        <th colspan="1"><input type="radio" name="LlaveRueda" id="" required></th>
                        <th colspan="1"><input type="radio" name="LlaveRueda" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="LlaveRueda_dano" id=""></th>
                        <td colspan="4">BISEL</td>
                        <th colspan="1"><input type="radio" name="Bisel" id="" required></th>
                        <th colspan="1"><input type="radio" name="Bisel" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Bisel_dano" id=""></th>
                        <th colspan="4" class="th2">OTROS</th>
                        <th colspan="1" class="th2">SI</th>
                        <th colspan="1" class="th2">NO</th>
                        <th colspan="1" class="th2">DAÑOS</th>
                    </tr>
                    <tr>
                        <td colspan="4">BOTONES DE PUERTA</td>
                        <th colspan="1"><input type="radio" name="BotonesDePuerta" id="" required></th>
                        <th colspan="1"><input type="radio" name="BotonesDePuerta" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="BotonesDePuerta_dano" id=""></th>
                        <td colspan="4">SEÑALES DE CARRETERA</td>
                        <th colspan="1"><input type="radio" name="SeñalesCarretera" id="" required></th>
                        <th colspan="1"><input type="radio" name="SeñalesCarretera" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="SeñalesCarretera_dano" id=""></th>
                        <td colspan="4">BRAZOS LIMPIADORES</td>
                        <th colspan="1"><input type="radio" name="BrazosLimpiadores" id="" required></th>
                        <th colspan="1"><input type="radio" name="BrazosLimpiadores" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="BrazosLimpiadores_dano" id=""></th>
                        <td colspan="4">QUEMACOCOS</td>
                        <th colspan="1"><input type="radio" name="Quemacocos" id="" required></th>
                        <th colspan="1"><input type="radio" name="Quemacocos" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Quemacocos_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">BOTONES RADIO O ESTEREO</td>
                        <th colspan="1"><input type="radio" name="BotonesRadioEstereo" id="" required></th>
                        <th colspan="1"><input type="radio" name="BotonesRadioEstereo" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="BotonesRadioEstereo_dano" id=""></th>
                        <td colspan="4">TAPETE CUBRE LLANTA</td>
                        <th colspan="1"><input type="radio" name="TapeteCubreLlanta" id="" required></th>
                        <th colspan="1"><input type="radio" name="TapeteCubreLlanta" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="TapeteCubreLlanta_dano" id=""></th>
                        <td colspan="4">COFRE</td>
                        <th colspan="1"><input type="radio" name="Cofre" id="" required></th>
                        <th colspan="1"><input type="radio" name="Cofre" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Cofre_dano" id=""></th>
                        <td colspan="4">COMPAC DISC</td>
                        <th colspan="1"><input type="radio" name="CompacDisc" id="" required></th>
                        <th colspan="1"><input type="radio" name="CompacDisc" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CompacDisc_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">CABECERAS</td>
                        <th colspan="1"><input type="radio" name="Cabeceras" id="" required></th>
                        <th colspan="1"><input type="radio" name="Cabeceras" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Cabeceras_dano" id=""></th>
                        <th colspan="4" class="th2">LADO DERECHO</th>
                        <th colspan="1" class="th2">SI</th>
                        <th colspan="1" class="th2">NO</th>
                        <th colspan="1" class="th2">DAÑOS</th>
                        <td colspan="4">CUARTOS DE LUZ</td>
                        <th colspan="1"><input type="radio" name="CuartosLuz" id="" required></th>
                        <th colspan="1"><input type="radio" name="CuartosLuz" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CuartosLuz_dano" id=""></th>
                        <td colspan="4">ANTENA</td>
                        <th colspan="1"><input type="radio" name="Antena" id="" required></th>
                        <th colspan="1"><input type="radio" name="Antena" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="Antena_dano" id=""></th>
                    </tr>
                    <tr>
                        <td colspan="4">SEGUROS</td>
                        <th colspan="1"><input type="radio" name="xxx" id="" required></th>
                        <th colspan="1"><input type="radio" name="xxx" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="xxx_dano" id=""></th>
                        <td colspan="4">CISTAL PUERTA DELANTERA</td>
                        <th colspan="1"><input type="radio" name="CristalPDelantera2" id="" required></th>
                        <th colspan="1"><input type="radio" name="CristalPDelantera2" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="CristalPDelantera2_dano" id=""></th>
                        <td colspan="4">EMBLEMAS</td>
                        <th colspan="1"><input type="radio" name="EmblemasFrente" id="" required></th>
                        <th colspan="1"><input type="radio" name="EmblemasFrente" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="EmblemasFrente_dano" id=""></th>
                        <td colspan="4">ESTEREO/TOCACINTAS</td>
                        <th colspan="1"><input type="radio" name="EstereoTocacintas" id="" required></th>
                        <th colspan="1"><input type="radio" name="EstereoTocacintas" id="" required></th>
                        <th colspan="1"><input type="checkbox" name="EstereoTocacintas_dano" id=""></th>
                    </tr>
                </tbody>
            </table>
    </div>
    <div class="section-title ">OBSERVACIONES:</div>
    <textarea class="input-textarea" name="observaciones"></textarea>

    <p>
        TERMINADA LA REPARACIÓN Y AVISADO EL ASEGURADO O CLIENTE ESTE TIENE DE PLAZO 2 DÍAS PARA RECOGER LA
        UNIDAD A
        PARTIR DEL 3er DÍA <b>EL ALMACENAJE CAUSARÁ CARGO A RAZÓN DE $150.00 POR DÍA</b>
    </p>
    <p>
        ESTIMADO CLIENTE HACEMOS DE SU CONOCIMIENTO NUESTRA EXCLUSIÓN EN LA RESPONSABILIDAD POR DAÑOS EN PIEZAS
        ELÉCTRICAS Y MECÁNICAS NO DERIVADAS DEL SINIESTRO
    </p>
    <p class="note">
        NOTA: La empresa por ningún motivo será responsable de los objetos no señalado en este inventario.
    </p>

    <table class="parte3">
        <tr>
            <td>
                CLIENTE (ENTREGA): <input type="text" name="cliente" id="" required>
            </td>
            <td>
                TALLER RECIBE CLIENTE (ENTREGA): <input type="text" name="taller" id="" required>
            </td>
        </tr>
        <tr>
            <td>
                TELÉFONOS: <input type="text" name="telefonos" required>
                CEL: <input type="text" name="cel" required>
            </td>

            <td>
                NOMBRE: <input type="text" name="nombre_taller" required>
            </td>
        </tr>
        <tr>
            <td>
                FIRMA: <input type="text" name="firma_cliente" required>
            </td>

            <td>
                FIRMA: <input type="text" name="firma_taller" required>
            </td>
        </tr>
        <tr>
            <td>
                CORREO ELECTRÓNICO: <input type="email" name="correo_electronico" required>
            </td>
        </tr>
    </table>

 
  

    
          </div>



  
    <asp:HiddenField ID="hidHtml" runat="server" />

    <asp:Literal ID="litMensaje" runat="server" />

      

   
<script>
function absolutizeUrl(url) {
    try { return new URL(url, document.baseURI).href; } catch(e) { return url; }
}

function snapshotForm() {
    try {
        const src = document.getElementById('formularioPDF');
        const clone = src.cloneNode(true);

        // 1) “Hornear” valores actuales de inputs/textarea/select
        clone.querySelectorAll('input, textarea, select').forEach(el => {
            const tag = el.tagName.toLowerCase();
            if (tag === 'textarea') {
                el.textContent = el.value ?? '';
                return;
            }
            if (tag === 'select') {
                Array.from(el.options).forEach(opt => {
                    if (opt.selected) opt.setAttribute('selected', 'selected'); else opt.removeAttribute('selected');
                });
                return;
            }
            if (el.type === 'checkbox' || el.type === 'radio') {
                if (el.checked) el.setAttribute('checked', 'checked'); else el.removeAttribute('checked');
                // Si no tienes value en radios/checkbox, no pasa nada: el “checked” ya queda impreso.
                return;
            }
            // text, number, date, email, etc.
            el.setAttribute('value', el.value ?? '');
        });

        // 2) Asegurar rutas absolutas de imágenes
        clone.querySelectorAll('img').forEach(img => {
            const src = img.getAttribute('src');
            if (src) img.setAttribute('src', absolutizeUrl(src));
        });

        // 3) Construir un HTML mínimo con tu <head> + el clon del contenedor
        const headHtml = document.querySelector('head').innerHTML;
        const bodyHtml = clone.outerHTML;
        const html = `<!doctype html>
<html>${headHtml.indexOf('<head') === -1 ? `<head>${headHtml}</head>` : headHtml}
<body>${bodyHtml}</body></html>`;

        // 4) Volcar al HiddenField
        document.getElementById('<%= hidHtml.ClientID %>').value = html;
        return true; // continúa el postback
    } catch (err) {
        alert('No se pudo preparar el contenido para PDF: ' + err);
        return false;
    }
}
</script> 
     </form>
</body>
  

</html>
