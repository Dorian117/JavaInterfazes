<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="modelo.AuditoriaDAO, modelo.Auditoria,
                 modelo.Conexion, java.sql.*,
                 java.util.List" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate, private");
    response.setHeader("Pragma",  "no-cache");
    response.setHeader("Expires", "0");

    String nUsuario = (String) session.getAttribute("nUsuario");
    if (nUsuario == null || nUsuario.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // Verificar que sea Administrador
    Connection conCheck = null;
    PreparedStatement stmtCheck = null;
    ResultSet rsCheck = null;
    boolean esAdmin = false;
    try {
        conCheck  = new Conexion().crearConexion();
        stmtCheck = conCheck.prepareStatement(
            "SELECT p.perfil FROM usuarios u " +
            "JOIN perfiles p ON u.id_perfil = p.id_perfil " +
            "WHERE u.usuario = ?"
        );
        stmtCheck.setString(1, nUsuario);
        rsCheck = stmtCheck.executeQuery();
        if (rsCheck.next()) {
            esAdmin = "Administrador".equals(rsCheck.getString("perfil"));
        }
    } finally {
        if (rsCheck   != null) try { rsCheck.close();   } catch (Exception ignored) {}
        if (stmtCheck != null) try { stmtCheck.close(); } catch (Exception ignored) {}
        if (conCheck  != null) try { conCheck.close();  } catch (Exception ignored) {}
    }
    if (!esAdmin) {
        response.sendRedirect(request.getContextPath() + "/front.jsp");
        return;
    }

    // Leer filtros
    String fUsuario = request.getParameter("fUsuario");
    String fAccion  = request.getParameter("fAccion");
    String fModulo  = request.getParameter("fModulo");
    String fDesde   = request.getParameter("fDesde");
    String fHasta   = request.getParameter("fHasta");

    boolean hayFiltro = (fUsuario != null || fAccion != null || fModulo != null
                         || fDesde != null || fHasta != null);

    AuditoriaDAO aDao = new AuditoriaDAO();
    List<Auditoria> lista = hayFiltro
        ? aDao.filtrar(fUsuario, fAccion, fModulo, fDesde, fHasta)
        : aDao.listarTodo();

    // Helper: devuelve clases CSS según acción
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Auditoría del Sistema</title>
    <style>
        /* ── Base dark mode ─────────────────────────────── */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #0f1117;
            color: #c9d1d9;
            padding: 22px 28px;
            min-height: 100vh;
        }

        /* ── Header ─────────────────────────────────────── */
        .header {
            display: flex; align-items: center; gap: 14px;
            margin-bottom: 22px; flex-wrap: wrap;
        }
        .header h2 {
            font-size: 22px; color: #e6edf3; font-weight: 700; flex: 1;
        }
        .badge-total {
            background: #1f6feb; color: #fff;
            padding: 4px 12px; border-radius: 20px;
            font-size: 13px; font-weight: 600;
        }
        .btn-limpiar {
            padding: 7px 16px; background: #3d1f1f;
            color: #ff6b6b; border: 1px solid #6b2020;
            border-radius: 6px; text-decoration: none;
            font-size: 13px; transition: background .2s;
        }
        .btn-limpiar:hover { background: #5a2020; }

        /* ── Filtros ─────────────────────────────────────── */
        .card-filtros {
            background: #161b22;
            border: 1px solid #30363d;
            border-radius: 8px;
            padding: 16px 18px;
            margin-bottom: 22px;
        }
        .card-filtros h3 {
            font-size: 14px; color: #8b949e;
            margin-bottom: 12px; letter-spacing: .5px; text-transform: uppercase;
        }
        .filtros-fila {
            display: flex; gap: 10px; flex-wrap: wrap; align-items: flex-end;
        }
        .filtro-item { display: flex; flex-direction: column; gap: 4px; }
        .filtro-item label { font-size: 12px; color: #8b949e; }
        .filtro-item input, .filtro-item select {
            background: #0d1117; color: #c9d1d9;
            border: 1px solid #30363d; border-radius: 5px;
            padding: 6px 10px; font-size: 13px; min-width: 140px;
        }
        .filtro-item input:focus, .filtro-item select:focus {
            outline: none; border-color: #1f6feb;
        }
        .btn-filtrar {
            padding: 8px 18px; background: #1f6feb; color: #fff;
            border: none; border-radius: 5px; cursor: pointer;
            font-size: 13px; font-weight: 600;
        }
        .btn-filtrar:hover { background: #388bfd; }
        .btn-limpiar-filtro {
            padding: 7px 14px; background: transparent;
            color: #8b949e; border: 1px solid #30363d;
            border-radius: 5px; text-decoration: none; font-size: 13px;
        }
        .btn-limpiar-filtro:hover { border-color: #8b949e; color: #c9d1d9; }

        /* ── Tabla ───────────────────────────────────────── */
        .tabla-wrap { overflow-x: auto; }
        table {
            width: 100%; border-collapse: collapse;
            font-size: 13px;
        }
        thead th {
            background: #161b22;
            color: #8b949e;
            padding: 10px 12px;
            text-align: left;
            border-bottom: 2px solid #30363d;
            font-weight: 600;
            white-space: nowrap;
        }
        tbody tr { border-bottom: 1px solid #21262d; transition: background .15s; }
        tbody tr:hover td { filter: brightness(1.3); }
        tbody td { padding: 8px 12px; vertical-align: middle; }

        /* Colores por acción */
        .row-login   { background: rgba(107,203,119,.08); border-left: 3px solid #6bcb77; }
        .row-logout  { background: rgba(160,160,176,.08); border-left: 3px solid #a0a0b0; }
        .row-crear   { background: rgba(0,212,255,.08);   border-left: 3px solid #00d4ff; }
        .row-editar  { background: rgba(255,217,61,.08);  border-left: 3px solid #ffd93d; }
        .row-eliminar{ background: rgba(255,71,87,.08);   border-left: 3px solid #ff4757; }
        .row-ver     { background: rgba(107,203,119,.05); border-left: 3px solid #52c068; }

        /* Badges de acción */
        .badge {
            display: inline-block; padding: 2px 9px;
            border-radius: 12px; font-size: 11px; font-weight: 700;
            letter-spacing: .4px; white-space: nowrap;
        }
        .badge-LOGIN    { background: #1a3d20; color: #6bcb77; border: 1px solid #6bcb77; }
        .badge-LOGOUT   { background: #2a2a35; color: #a0a0b0; border: 1px solid #a0a0b0; }
        .badge-CREAR    { background: #00212e; color: #00d4ff; border: 1px solid #00d4ff; }
        .badge-EDITAR   { background: #2e2700; color: #ffd93d; border: 1px solid #ffd93d; }
        .badge-ELIMINAR { background: #300; color: #ff4757;    border: 1px solid #ff4757; }
        .badge-VER      { background: #152518; color: #52c068; border: 1px solid #52c068; }

        /* Badges de módulo */
        .mod {
            display: inline-block; padding: 2px 8px;
            border-radius: 4px; font-size: 11px;
            background: #21262d; color: #8b949e;
            border: 1px solid #30363d;
        }

        .sin-datos {
            text-align: center; padding: 40px;
            color: #8b949e; font-size: 14px;
        }
        .num-col { color: #58a6ff; font-size: 12px; }
        .ip-col  { color: #6e7681; font-size: 11px; font-family: monospace; }
        .fecha-col { white-space: nowrap; font-size: 11px; color: #8b949e; }
    </style>
</head>
<body>

<!-- ── Header ───────────────────────────────────────── -->
<div class="header">
    <h2>&#128203; Registro de Auditoría</h2>
    <span class="badge-total"><%= lista.size() %> registro(s)</span>
    <a href="controladorAuditoria?accion=limpiar"
       class="btn-limpiar"
       onclick="return confirm('¿Eliminar todos los registros anteriores a 30 días? Esta acción no se puede deshacer.')">
        &#128465; Limpiar &gt; 30 días
    </a>
</div>

<!-- ── Filtros ───────────────────────────────────────── -->
<div class="card-filtros">
    <h3>&#128269; Filtros</h3>
    <form method="GET" action="auditoria.jsp">
        <div class="filtros-fila">
            <div class="filtro-item">
                <label>Usuario</label>
                <input type="text" name="fUsuario" placeholder="Nombre de usuario"
                       value="<%= fUsuario != null ? fUsuario : "" %>">
            </div>
            <div class="filtro-item">
                <label>Acción</label>
                <select name="fAccion">
                    <option value="">— Todas —</option>
                    <% String[] acciones = {"LOGIN","LOGOUT","CREAR","EDITAR","ELIMINAR","VER"};
                       for (String ac : acciones) { %>
                    <option value="<%= ac %>" <%= ac.equals(fAccion) ? "selected" : "" %>><%= ac %></option>
                    <% } %>
                </select>
            </div>
            <div class="filtro-item">
                <label>Módulo</label>
                <select name="fModulo">
                    <option value="">— Todos —</option>
                    <% String[] modulos = {"SISTEMA","USUARIO","TAREA","EXAMEN","HORARIO","MATERIA","NOTIFICACION","ROL","ACTIVIDAD"};
                       for (String mod : modulos) { %>
                    <option value="<%= mod %>" <%= mod.equals(fModulo) ? "selected" : "" %>><%= mod %></option>
                    <% } %>
                </select>
            </div>
            <div class="filtro-item">
                <label>Desde</label>
                <input type="date" name="fDesde" value="<%= fDesde != null ? fDesde : "" %>">
            </div>
            <div class="filtro-item">
                <label>Hasta</label>
                <input type="date" name="fHasta" value="<%= fHasta != null ? fHasta : "" %>">
            </div>
            <button type="submit" class="btn-filtrar">&#128269; Filtrar</button>
            <a href="auditoria.jsp" class="btn-limpiar-filtro">&#10006; Limpiar</a>
        </div>
    </form>
</div>

<!-- ── Tabla ─────────────────────────────────────────── -->
<div class="tabla-wrap">
    <% if (lista.isEmpty()) { %>
    <div class="sin-datos">No hay registros de auditoría para los filtros seleccionados.</div>
    <% } else { %>
    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Usuario</th>
                <th>Nombre</th>
                <th>Acción</th>
                <th>Módulo</th>
                <th>Descripción</th>
                <th>IP</th>
                <th>Fecha / Hora</th>
            </tr>
        </thead>
        <tbody>
            <%
                int contador = 1;
                for (Auditoria a : lista) {
                    String ac  = a.getAccion() != null ? a.getAccion() : "";
                    String rowClass;
                    switch (ac) {
                        case "LOGIN":    rowClass = "row-login";    break;
                        case "LOGOUT":   rowClass = "row-logout";   break;
                        case "CREAR":    rowClass = "row-crear";    break;
                        case "EDITAR":   rowClass = "row-editar";   break;
                        case "ELIMINAR": rowClass = "row-eliminar"; break;
                        case "VER":      rowClass = "row-ver";      break;
                        default:         rowClass = "";
                    }
            %>
            <tr class="<%= rowClass %>">
                <td class="num-col"><%= contador++ %></td>
                <td><strong><%= a.getUsuario() != null ? a.getUsuario() : "" %></strong></td>
                <td><%= a.getNombre_completo() != null ? a.getNombre_completo() : "" %></td>
                <td>
                    <span class="badge badge-<%= ac %>"><%= ac %></span>
                </td>
                <td>
                    <span class="mod"><%= a.getModulo() != null ? a.getModulo() : "" %></span>
                </td>
                <td><%= a.getDescripcion() != null ? a.getDescripcion() : "" %></td>
                <td class="ip-col"><%= a.getIp_address() != null ? a.getIp_address() : "" %></td>
                <td class="fecha-col"><%= a.getFecha() %></td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <% } %>
</div>

</body>
</html>
