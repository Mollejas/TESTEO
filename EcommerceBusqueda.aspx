<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcommerceBusqueda.aspx.vb" Inherits="TEST1.EcommerceBusqueda" %>


<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Catálogo Informativo</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* ====== Variables de marca ====== */
        :root{
            --brand-blue:#1a2b5c;
            --brand-red:#cc0a2f;
            --brand-white:#fff;
            --muted:#f5f6fb;
            --shadow-light: 0 2px 12px rgba(26, 43, 92, 0.08);
            --shadow-medium: 0 8px 25px rgba(26, 43, 92, 0.12);
            --shadow-heavy: 0 15px 35px rgba(26, 43, 92, 0.15);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* ====== Base ====== */
        * {
            transition: var(--transition);
        }
        
        body {
            background: linear-gradient(135deg, #f5f6fb 0%, #e8ecf3 100%);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            line-height: 1.6;
            min-height: 100vh;
        }

        /* ====== Encabezado mejorado ====== */
        .brand-bar {
            background: linear-gradient(135deg, var(--brand-blue) 0%, #2f4fa0 50%, #4a6bb3 100%);
            color: var(--brand-white);
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-medium);
        }

        .brand-bar::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" fill-opacity="0.03"/><circle cx="75" cy="75" r="1" fill="white" fill-opacity="0.03"/><circle cx="50" cy="10" r="1" fill="white" fill-opacity="0.02"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            pointer-events: none;
        }

        .brand-bar .container {
            position: relative;
            z-index: 1;
        }

        .brand-bar .badge {
            background: rgba(255, 255, 255, 0.15) !important;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            font-weight: 500;
        }

        /* ====== Panel izquierdo mejorado ====== */
        .sidebar {
            position: sticky;
            top: 1.5rem;
            background: var(--brand-white);
            border-radius: 1.25rem;
            box-shadow: var(--shadow-light);
            border: 1px solid rgba(26, 43, 92, 0.06);
            backdrop-filter: blur(20px);
            overflow: hidden;
        }

        .sidebar:hover {
            box-shadow: var(--shadow-medium);
            transform: translateY(-2px);
        }

        .sidebar h6 {
            color: var(--brand-blue);
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .sidebar h6 i {
            font-size: 1.1rem;
        }

        /* ====== Formularios mejorados ====== */
        .form-select, .form-control {
            border: 2px solid #e3e8f0;
            border-radius: 0.75rem;
            padding: 0.75rem 1rem;
            font-weight: 500;
            background: var(--brand-white);
            transition: var(--transition);
        }

        .form-select:focus, .form-control:focus {
            border-color: var(--brand-blue);
            box-shadow: 0 0 0 3px rgba(26, 43, 92, 0.1);
            transform: translateY(-1px);
        }

        .form-select:hover, .form-control:hover {
            border-color: var(--brand-blue);
            transform: translateY(-1px);
        }

        .form-label {
            font-weight: 600;
            color: var(--brand-blue);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.5rem;
        }

        /* ====== Tarjetas de resultado mejoradas ====== */
        .card-result {
            border: 0;
            border-radius: 1.25rem;
            box-shadow: var(--shadow-light);
            overflow: hidden;
            position: relative;
            transition: var(--transition);
            background: var(--brand-white);
        }

        .card-result::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 0%, rgba(26, 43, 92, 0.02) 50%, transparent 100%);
            opacity: 0;
            transition: var(--transition);
        }

        .card-result:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: var(--shadow-heavy);
        }

        .card-result:hover::before {
            opacity: 1;
        }

        /* Mejora del contenedor de imagen */
        .card-result .img-box {
            width: 100%;
            aspect-ratio: 4 / 3;
            background: linear-gradient(135deg, #f8f9fc 0%, #e9ecef 100%);
            border-top-left-radius: 1.25rem;
            border-top-right-radius: 1.25rem;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .card-result .img-box::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.1) 50%, transparent 70%);
            transform: translateX(-100%);
            transition: transform 0.6s ease;
        }

        .card-result:hover .img-box::before {
            transform: translateX(100%);
        }

        .card-result .img-box img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            transition: var(--transition);
        }

        .card-result:hover .img-box img {
            transform: scale(1.05);
        }

        /* Fallback para imágenes directas */
        .card-result > img {
            width: 100%;
            height: 220px;
            object-fit: contain;
            background: linear-gradient(135deg, #f8f9fc 0%, #e9ecef 100%);
            border-top-left-radius: 1.25rem;
            border-top-right-radius: 1.25rem;
        }

        /* Mejora del cuerpo de la tarjeta */
        .card-result .card-body {
            padding: 1.5rem;
            position: relative;
        }

        .card-result .card-body p {
            font-weight: 500;
            color: #495057;
            line-height: 1.5;
            margin-bottom: 1rem;
        }

        /* ====== Badges y chips mejorados ====== */
        .badge-chip {
            background: linear-gradient(135deg, var(--brand-blue) 0%, #2f4fa0 100%);
            color: var(--brand-white);
            border-radius: 2rem;
            padding: 0.45rem 0.85rem;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            box-shadow: 0 2px 8px rgba(26, 43, 92, 0.2);
            transition: var(--transition);
        }

        .badge-chip:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(26, 43, 92, 0.3);
        }

        .badge.bg-light {
            background: rgba(26, 43, 92, 0.08) !important;
            color: var(--brand-blue) !important;
            border: 1px solid rgba(26, 43, 92, 0.12);
            font-weight: 500;
            transition: var(--transition);
        }

        .badge.bg-light:hover {
            background: rgba(26, 43, 92, 0.12) !important;
            transform: translateY(-1px);
        }

        /* ====== Botones mejorados ====== */
        .btn {
            border-radius: 0.75rem;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            font-size: 0.85rem;
            transition: var(--transition);
            border: 2px solid transparent;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--brand-red) 0%, #a70926 100%);
            border-color: var(--brand-red);
            box-shadow: 0 4px 12px rgba(204, 10, 47, 0.3);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #a70926 0%, #8a0621 100%);
            border-color: #a70926;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(204, 10, 47, 0.4);
        }

        .btn-outline-primary, .btn-outline-danger {
            background: transparent;
            border: 2px solid;
            position: relative;
            overflow: hidden;
        }

        .btn-outline-danger {
            border-color: var(--brand-red);
            color: var(--brand-red);
        }

        .btn-outline-danger::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: var(--brand-red);
            transition: left 0.3s ease;
            z-index: 0;
        }

        .btn-outline-danger:hover::before {
            left: 0;
        }

        .btn-outline-danger:hover {
            color: var(--brand-white);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(204, 10, 47, 0.3);
        }

        .btn-light {
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid #e3e8f0;
            color: var(--brand-blue);
        }

        .btn-light:hover {
            background: var(--brand-white);
            border-color: var(--brand-blue);
            color: var(--brand-blue);
            transform: translateY(-2px);
            box-shadow: var(--shadow-light);
        }

        /* ====== Barra de resultados mejorada ====== */
        .results-bar {
            background: var(--brand-white);
            border-radius: 1rem;
            padding: 1rem 1.5rem;
            display: flex;
            gap: 1rem;
            align-items: center;
            box-shadow: var(--shadow-light);
            border: 1px solid rgba(26, 43, 92, 0.06);
        }

        /* ====== Lista clickeable mejorada ====== */
        .clickable-list a {
            display: block;
            padding: 0.75rem 1rem;
            border-radius: 0.75rem;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 0.25rem;
            transition: var(--transition);
            position: relative;
        }

        .clickable-list a:hover {
            background: rgba(26, 43, 92, 0.05);
            transform: translateX(4px);
        }

        .clickable-list a.active-tsuru {
            font-weight: 700;
            font-size: 1.05rem;
            color: var(--brand-blue);
            background: rgba(26, 43, 92, 0.08);
            border-left: 4px solid var(--brand-red);
            padding-left: 1rem;
        }

        /* ====== Mensajes vacíos mejorados ====== */
        .empty {
            color: #6c757d;
            border: 2px dashed #ced4da;
            border-radius: 1.25rem;
            padding: 3rem 2rem;
            background: var(--brand-white);
            text-align: center;
            font-weight: 500;
        }

        .empty i {
            font-size: 2rem;
            opacity: 0.6;
            margin-bottom: 0.5rem;
        }

        /* ====== Títulos y separadores mejorados ====== */
        .section-title {
            font-size: 0.9rem;
            font-weight: 700;
            color: #495057;
            margin-bottom: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .divider {
            height: 1px;
            background: linear-gradient(90deg, transparent 0%, #e9ecef 50%, transparent 100%);
            margin: 1.5rem 0;
        }

        /* ====== Precios destacados ====== */
        .price-display {
            color: var(--brand-red) !important;
            font-weight: 700 !important;
            font-size: 1.1rem !important;
            text-shadow: 0 1px 2px rgba(204, 10, 47, 0.1);
        }

        /* ====== Pequeñas mejoras tipográficas ====== */
        .small-hint {
            font-size: 0.85rem;
            color: #6c757d;
            font-weight: 500;
        }

        /* ====== Panel principal mejorado ====== */
        .search-panel {
            background: var(--brand-white);
            border-radius: 1.25rem;
            box-shadow: var(--shadow-light);
            border: 1px solid rgba(26, 43, 92, 0.06);
            position: relative;
            overflow: hidden;
        }

        .search-panel::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--brand-blue) 0%, var(--brand-red) 100%);
        }

        .search-panel h5 {
            color: var(--brand-blue);
            font-weight: 700;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .search-panel h5 i {
            font-size: 1.2rem;
        }

        /* ====== Animaciones de carga sutiles ====== */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card-result {
            animation: fadeInUp 0.5s ease forwards;
        }

        .card-result:nth-child(2) { animation-delay: 0.1s; }
        .card-result:nth-child(3) { animation-delay: 0.2s; }
        .card-result:nth-child(4) { animation-delay: 0.3s; }

        /* ====== Responsividad mejorada ====== */
        @media (min-width: 992px) {
            .card-result > img { height: 260px; }
            .card-result .img-box { aspect-ratio: 16 / 9; }
        }

        @media (max-width: 768px) {
            .sidebar {
                position: relative;
                top: 0;
                margin-bottom: 1.5rem;
            }
            
            .card-result:hover {
                transform: translateY(-4px) scale(1.01);
            }
            
            .btn {
                padding: 0.65rem 1.25rem;
                font-size: 0.8rem;
            }
        }

        /* ====== Efectos de scroll suaves ====== */
        html {
            scroll-behavior: smooth;
        }

        /* ====== Mejoras en accesibilidad ====== */
        .btn:focus, .form-select:focus, .form-control:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(26, 43, 92, 0.2);
        }

        /* ====== Indicadores de estado ====== */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
<asp:ScriptManager ID="sm" runat="server" />

<!-- ENCABEZADO -->
<div class="brand-bar py-3">
  <div class="container d-flex align-items-center justify-content-between">
    <div class="d-flex align-items-center gap-3">
      <span class="badge bg-light text-dark">
        <i class="bi bi-car-front me-1"></i>
        Catálogo Informativo
      </span>
      <span class="small-hint">DB: TEST · LIBRO4 (cascada) / LIBRO1 (resultados)</span>
    </div>
    <strong>
      <i class="bi bi-palette me-2"></i>
      Rojo · Azul · Blanco
    </strong>
  </div>
</div>

<div class="container my-4">
  <div class="row g-4">

    <!-- LADO IZQUIERDO -->
    <div class="col-12 col-lg-3">
      <div class="sidebar p-4">
        <asp:UpdatePanel ID="upLeft" runat="server" UpdateMode="Conditional">
          <ContentTemplate>
            <!-- Filtros adicionales existentes -->
            <h6 class="mb-3">
              <i class="bi bi-funnel"></i>
              Filtros adicionales
            </h6>
            <div class="small-hint mb-3">Se habilitan después de la primera búsqueda.</div>

            <div class="mb-3">
              <label class="form-label">
                <i class="bi bi-diagram-3 me-1"></i>
                Grupo
              </label>
              <asp:CheckBoxList ID="chkGrupo" runat="server" />
            </div>
            <div class="mb-3">
              <label class="form-label">
                <i class="bi bi-tags me-1"></i>
                Tipo
              </label>
              <asp:CheckBoxList ID="chkTipo" runat="server" />
            </div>
            
            <div class="d-grid gap-2">
              <asp:Button ID="btnRefinar" runat="server" CssClass="btn btn-outline-primary" Text="Refinar resultados" OnClick="btnRefinar_Click" />
              <asp:Button ID="btnLimpiarFiltros" runat="server" CssClass="btn btn-light" Text="Limpiar filtros" OnClick="btnLimpiarFiltros_Click" />
            </div>

            <div class="divider"></div>

            <!-- Lista de GRUPOS para modo TSURU (izquierda) -->
            <asp:Panel ID="pnlGrupoTsuru" runat="server" Visible="false">
              <div class="section-title">
                <i class="bi bi-diagram-3 me-1"></i>
                Grupos (TSURU)
              </div>
              <div class="small-hint mb-3">Clic para filtrar por grupo o "Todos".</div>
              <asp:BulletedList ID="bltGrupoTsuru" runat="server"
                                DisplayMode="LinkButton"
                                CssClass="clickable-list"
                                OnClick="bltGrupoTsuru_Click">
              </asp:BulletedList>
            </asp:Panel>

          </ContentTemplate>
          <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnTsuru" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="bltGrupoTsuru" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnBuscar" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnRefinar" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnLimpiarFiltros" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnLimpiar" EventName="Click" />
          </Triggers>
        </asp:UpdatePanel>
      </div>
    </div>

    <!-- LADO DERECHO -->
    <div class="col-12 col-lg-9">

      <div class="search-panel p-4">
        <h5>
          <i class="bi bi-search"></i>
          Buscar por catálogo de autos
        </h5>

        <asp:UpdatePanel ID="upFilters" runat="server" UpdateMode="Conditional">
          <ContentTemplate>
            <div class="row g-3">
              <div class="col-6 col-md-2">
                <label for="ddlAno" class="form-label">
                  <i class="bi bi-calendar me-1"></i>
                  Año
                </label>
                <asp:DropDownList ID="ddlAno" runat="server" CssClass="form-select"
                    AutoPostBack="True" OnSelectedIndexChanged="ddlAno_SelectedIndexChanged" />
              </div>
              <div class="col-6 col-md-2">
                <label for="ddlMarca" class="form-label">
                  <i class="bi bi-award me-1"></i>
                  Marca
                </label>
                <asp:DropDownList ID="ddlMarca" runat="server" CssClass="form-select"
                    AutoPostBack="True" OnSelectedIndexChanged="ddlMarca_SelectedIndexChanged" />
              </div>
              <div class="col-6 col-md-2">
                <label for="ddlModelo" class="form-label">
                  <i class="bi bi-car-front me-1"></i>
                  Modelo
                </label>
                <asp:DropDownList ID="ddlModelo" runat="server" CssClass="form-select"
                    AutoPostBack="True" OnSelectedIndexChanged="ddlModelo_SelectedIndexChanged" />
              </div>
              <div class="col-6 col-md-3">
                <label for="ddlSubmodelo" class="form-label">
                  <i class="bi bi-speedometer2 me-1"></i>
                  Submodelo
                </label>
                <asp:DropDownList ID="ddlSubmodelo" runat="server" CssClass="form-select"
                    AutoPostBack="True" OnSelectedIndexChanged="ddlSubmodelo_SelectedIndexChanged" />
              </div>
              <div class="col-6 col-md-3">
                <label for="ddlMotor" class="form-label">
                  <i class="bi bi-gear me-1"></i>
                  Motor_L
                </label>
                <asp:DropDownList ID="ddlMotor" runat="server" CssClass="form-select" />
              </div>
            </div>

            <div class="mt-4 d-flex gap-2 flex-wrap">
              <asp:Button ID="btnBuscar" runat="server" CssClass="btn btn-primary" Text="🔍 Buscar" OnClick="btnBuscar_Click" />
              <asp:Button ID="btnLimpiar" runat="server" CssClass="btn btn-light" Text="🧹 Limpiar" OnClick="btnLimpiar_Click" />
              <asp:Button ID="btnTsuru" runat="server" CssClass="btn btn-outline-danger" Text="⚡ TSURU" OnClick="btnTsuru_Click" />
            </div>
          </ContentTemplate>
        </asp:UpdatePanel>
      </div>

      <div class="mt-3 results-bar">
        <span class="badge-chip">
          <i class="bi bi-list-ul me-1"></i>
          <asp:Label ID="lblCount" runat="server" Text="0"></asp:Label> resultados
        </span>
        <asp:Label ID="lblCriteria" runat="server" CssClass="small-hint"></asp:Label>
        <asp:Label ID="lblMsg" runat="server" CssClass="small-hint ms-auto text-danger"></asp:Label>
      </div>

      <asp:UpdatePanel ID="upResults" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
          <div class="row g-4 mt-2">
            <asp:Repeater ID="rptResultados" runat="server">
              <ItemTemplate>
                <div class="col-12 col-sm-6 col-lg-4">
                  <div class="card card-result h-100">
                    <div class="img-box">
                      <img src='<%# Eval("ImgUrl") %>' alt='<%# Eval("artclave") %>' onerror="this.onerror=null;this.src='images/no-image.png';" />
                    </div>
                    <div class="card-body">
                      <div class="d-flex justify-content-between align-items-start mb-3">
                        <span class="badge-chip">
                          <i class="bi bi-tag me-1"></i>
                          <%# Eval("artclave") %>
                        </span>
                        <span class="price-display">
                          💰 $<%# String.Format(System.Globalization.CultureInfo.GetCultureInfo("es-MX"), "{0:N2}", Eval("precio")) %></span></div>
                      <p class="mb-3"><%# Eval("descripcion") %></p>
                      <div class="d-flex gap-2 flex-wrap">
                        <span class="badge bg-light text-dark">
                          <i class="bi bi-diagram-3 me-1"></i>
                          <%# Eval("grupodesc") %>
                        </span>
                        <span class="badge bg-light text-dark">
                          <i class="bi bi-tag me-1"></i>
                          <%# Eval("tipodesc") %>
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
              </ItemTemplate>
            </asp:Repeater>
          </div>

          <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty mt-4" Visible="false">
            <i class="bi bi-inbox d-block mb-2"></i>
            <strong>No se encontraron coincidencias</strong>
            <div class="mt-2">Ajusta los filtros para encontrar más productos.</div>
          </asp:Panel>
        </ContentTemplate>
        <Triggers>
          <asp:AsyncPostBackTrigger ControlID="btnBuscar" EventName="Click" />
          <asp:AsyncPostBackTrigger ControlID="btnRefinar" EventName="Click" />
          <asp:AsyncPostBackTrigger ControlID="btnLimpiarFiltros" EventName="Click" />
          <asp:AsyncPostBackTrigger ControlID="btnTsuru" EventName="Click" />
          <asp:AsyncPostBackTrigger ControlID="bltGrupoTsuru" EventName="Click" />
        </Triggers>
      </asp:UpdatePanel>

    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Pequeñas mejoras de interactividad
    document.addEventListener('DOMContentLoaded', function () {
        // Efecto de carga suave en las tarjetas
        const cards = document.querySelectorAll('.card-result');
        cards.forEach((card, index) => {
            card.style.animationDelay = (index * 0.1) + 's';
        });

        // Mejorar la experiencia de los dropdowns
        const selects = document.querySelectorAll('.form-select');
        selects.forEach(select => {
            select.addEventListener('focus', function () {
                this.parentElement.style.transform = 'translateY(-2px)';
            });

            select.addEventListener('blur', function () {
                this.parentElement.style.transform = 'translateY(0)';
            });
        });
    });
</script>

</form>
</body>
</html>