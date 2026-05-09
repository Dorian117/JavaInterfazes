<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="modelo.PerfilDAO, modelo.Perfil, modelo.Actividad, java.util.List, java.util.List" %>
<%
    String nUsuario = (String) session.getAttribute("nUsuario");
    if (nUsuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    PerfilDAO dao              = new PerfilDAO();
    List<Perfil>    perfiles   = dao.listarPerfiles();
    List<Actividad> actividades = dao.listarActividades();

    String error    = request.getParameter("error");
    String idError  = request.getParameter("idPerfil");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Roles</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; color: #333; }
        h2   { color: #4a90d9; border-bottom: 2px solid #4a90d9; padding-bottom: 6px; }
        h3   { color: #555; margin-top: 0; }

        .seccion {
            background: #f9f9f9; border: 1px solid #ddd; border-radius: 6px;
            padding: 16px 20px; margin-bottom: 24px;
        }

        .form-fila { display: flex; align-items: center; gap: 12px; margin-bottom: 10px; flex-wrap: wrap; }
        .form-fila label { font-weight: bold; min-width: 140px; }
        input[type=text] {
            padding: 7px; border: 1px solid #ccc; border-radius: 4px; width: 240px;
        }

        .checks { display: flex; flex-wrap: wrap; gap: 8px 20px; margin: 8px 0 14px 0; }
        .checks label { font-weight: normal; cursor: pointer; }

        input[type=submit], .btn {
            padding: 7px 18px; border: none; border-radius: 4px;
            cursor: pointer; font-size: 14px; text-decoration: none;
            display: inline-block;
        }
        .btn-primary  { background: #4a90d9; color: #fff; }
        .btn-primary:hover  { background: #357abd; }
        .btn-warning  { background: #e67e22; color: #fff; }
        .btn-warning:hover  { background: #ca6f1e; }
        .btn-danger   { background: #e74c3c; color: #fff; }
        .btn-danger:hover   { background: #c0392b; }

        table { border-collapse: collapse; width: 100%; }
        th { background: #4a90d9; color: #fff; padding: 8px 12px; text-align: left; }
        td { padding: 7px 12px; border-bottom: 1px solid #ddd; vertical-align: top; }
        tr:hover td { background: #f0f6ff; }

        .actividades-asignadas { font-size: 13px; color: #555; }
        .alerta { background: #fdecea; border: 1px solid #e74c3c; color: #c0392b;
                  padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; }
    </style>
</head>
<body>

<h2>Gestión de Roles y Permisos</h2>

<%-- Aviso si no se pudo eliminar --%>
<%
    if ("tieneUsuarios".equals(error)) {
        PerfilDAO daoErr = new PerfilDAO();
        modelo.Perfil pErr = daoErr.buscarPerfil(Integer.parseInt(idError));
        String nomErr = pErr != null ? pErr.getPerfil() : "ID " + idError;
%>
<div class="alerta">
    No se puede eliminar el rol "<strong><%= nomErr %></strong>" porque tiene usuarios asignados.
</div>
<% } %>

<%-- ===== SECCIÓN 1: CREAR NUEVO ROL ===== --%>
<div class="seccion">
    <h3>Crear nuevo rol</h3>
    <form action="controladorPerfil?accion=crear" method="POST">

        <div class="form-fila">
            <label for="nombrePerfil">Nombre del rol:</label>
            <input type="text" id="nombrePerfil" name="nombrePerfil"
                   maxlength="30" required placeholder="Ej: Supervisor">
        </div>

        <div class="form-fila">
            <label>Actividades permitidas:</label>
        </div>
        <div class="checks">
            <% for (Actividad a : actividades) { %>
            <label>
                <input type="checkbox" name="actividades[]"
                       value="<%= a.getId_actividad() %>">
                <%= a.getNom_actividad() %>
            </label>
            <% } %>
        </div>

        <input type="submit" class="btn btn-primary" value="Crear Rol">
    </form>
</div>

<%-- ===== SECCIÓN 2: TABLA DE ROLES EXISTENTES ===== --%>
<div class="seccion">
    <h3>Roles existentes</h3>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre del Rol</th>
                <th>Actividades Asignadas</th>
                <th>Editar</th>
                <th>Eliminar</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Perfil p : perfiles) {
                    List<Integer> idsAsig = dao.obtenerActividadesDePerfil(p.getId_perfil());
                    StringBuilder sbActs  = new StringBuilder();
                    for (Actividad a : actividades) {
                        if (idsAsig.contains(a.getId_actividad())) {
                            if (sbActs.length() > 0) sbActs.append(", ");
                            sbActs.append(a.getNom_actividad());
                        }
                    }
                    String actsStr = sbActs.length() > 0 ? sbActs.toString() : "— sin actividades —";
            %>
            <tr>
                <td><%= p.getId_perfil() %></td>
                <td><strong><%= p.getPerfil() %></strong></td>
                <td class="actividades-asignadas"><%= actsStr %></td>
                <td>
                    <a href="editarRol.jsp?id=<%= p.getId_perfil() %>"
                       class="btn btn-warning">Editar</a>
                </td>
                <td>
                    <a href="controladorPerfil?accion=eliminar&idPerfil=<%= p.getId_perfil() %>"
                       class="btn btn-danger"
                       onclick="return confirm('¿Eliminar el rol <%= p.getPerfil() %>?')">
                        Eliminar
                    </a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

</body>
</html>
