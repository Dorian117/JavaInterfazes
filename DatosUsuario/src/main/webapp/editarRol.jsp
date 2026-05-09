<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="modelo.PerfilDAO, modelo.Perfil, modelo.Actividad, java.util.List" %>
<%
    String nUsuario = (String) session.getAttribute("nUsuario");
    if (nUsuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect("gestionRoles.jsp");
        return;
    }
    int idPerfil = Integer.parseInt(idParam);

    PerfilDAO dao               = new PerfilDAO();
    Perfil    perfil            = dao.buscarPerfil(idPerfil);
    List<Actividad> actividades = dao.listarActividades();
    List<Integer>   asignadas   = dao.obtenerActividadesDePerfil(idPerfil);

    if (perfil == null) {
        response.sendRedirect("gestionRoles.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Rol - <%= perfil.getPerfil() %></title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; color: #333; }
        h2   { color: #4a90d9; border-bottom: 2px solid #4a90d9; padding-bottom: 6px; }
        .seccion {
            background: #f9f9f9; border: 1px solid #ddd; border-radius: 6px;
            padding: 16px 20px; max-width: 600px;
        }
        .nombre-rol { font-size: 20px; font-weight: bold; color: #4a90d9; margin-bottom: 14px; }
        .checks { display: flex; flex-wrap: wrap; gap: 10px 24px; margin: 10px 0 18px 0; }
        .checks label { cursor: pointer; }
        .checks label:hover { color: #4a90d9; }
        input[type=submit] {
            padding: 8px 22px; background: #4a90d9; color: #fff;
            border: none; border-radius: 4px; cursor: pointer; font-size: 14px;
        }
        input[type=submit]:hover { background: #357abd; }
        .btn-volver {
            display: inline-block; margin-left: 12px;
            padding: 8px 16px; background: #95a5a6; color: #fff;
            border-radius: 4px; text-decoration: none; font-size: 14px;
        }
        .btn-volver:hover { background: #7f8c8d; }
        p.info { color: #777; font-size: 13px; margin-top: 4px; }
    </style>
</head>
<body>

<h2>Editar Permisos del Rol</h2>

<div class="seccion">
    <div class="nombre-rol"><%= perfil.getPerfil() %></div>
    <p class="info">Selecciona las actividades que este rol puede acceder:</p>

    <form action="controladorPerfil?accion=editar" method="POST">
        <input type="hidden" name="idPerfil" value="<%= perfil.getId_perfil() %>">

        <div class="checks">
            <% for (Actividad a : actividades) {
                   boolean marcado = asignadas.contains(a.getId_actividad());
            %>
            <label>
                <input type="checkbox" name="actividades[]"
                       value="<%= a.getId_actividad() %>"
                       <%= marcado ? "checked" : "" %>>
                <%= a.getNom_actividad() %>
                <small style="color:#999">(<%= a.getEnlace() %>)</small>
            </label>
            <% } %>
        </div>

        <input type="submit" value="Guardar cambios">
        <a href="gestionRoles.jsp" class="btn-volver">Cancelar</a>
    </form>
</div>

</body>
</html>
