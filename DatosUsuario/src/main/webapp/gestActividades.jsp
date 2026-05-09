<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="modelo.Conexion, java.sql.*" %>
<%
    String nUsuario = (String) session.getAttribute("nUsuario");
    if (nUsuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String error   = request.getParameter("error");
    String idError = request.getParameter("id");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Actividades</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; color: #333; }
        h2   { color: #4a90d9; border-bottom: 2px solid #4a90d9; padding-bottom: 6px; }
        table { border-collapse: collapse; width: 100%; }
        th { background: #4a90d9; color: #fff; padding: 8px 12px; text-align: left; }
        td { padding: 7px 12px; border-bottom: 1px solid #ddd; }
        tr:hover td { background: #f0f6ff; }
        a { text-decoration: none; }
        .btn {
            padding: 5px 12px; border-radius: 4px; font-size: 13px;
            display: inline-block; color: #fff;
        }
        .btn-warning { background: #e67e22; }
        .btn-warning:hover { background: #ca6f1e; }
        .btn-danger  { background: #e74c3c; }
        .btn-danger:hover  { background: #c0392b; }
        .alerta { background: #fdecea; border: 1px solid #e74c3c; color: #c0392b;
                  padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; }
        .btn-nueva {
            display: inline-block; margin-bottom: 16px;
            padding: 8px 18px; background: #27ae60; color: #fff;
            border-radius: 4px; font-size: 14px;
        }
        .btn-nueva:hover { background: #1e8449; }
    </style>
</head>
<body>

<h2>Gestión de Actividades</h2>

<%
    if ("asignada".equals(error)) {
%>
<div class="alerta">
    No se puede eliminar: la actividad está asignada a uno o más perfiles.
    Quita la asignación en <a href="gestionRoles.jsp">Gestión de Roles</a> primero.
</div>
<% } %>

<a href="regActividad.jsp" class="btn-nueva">+ Nueva Actividad</a>

<%
    Connection con = null;
    Statement  stmt = null;
    ResultSet  rs   = null;
    try {
        con  = new Conexion().crearConexion();
        stmt = con.createStatement();
        rs   = stmt.executeQuery("SELECT * FROM actividades ORDER BY id_actividad");
%>
<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Enlace</th>
            <th>Editar</th>
            <th>Eliminar</th>
        </tr>
    </thead>
    <tbody>
        <% while (rs.next()) {
               int    id  = rs.getInt("id_actividad");
               String nom = rs.getString("nom_actividad");
               String enl = rs.getString("enlace");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= nom %></td>
            <td><%= enl %></td>
            <td>
                <a href="editarActividad.jsp?id=<%= id %>" class="btn btn-warning">Editar</a>
            </td>
            <td>
                <a href="controladorActividad?accion=eliminar&id=<%= id %>"
                   class="btn btn-danger"
                   onclick="return confirm('¿Eliminar la actividad <%= nom %>?')">
                    Eliminar
                </a>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>
<%
    } catch (Exception e) {
        e.printStackTrace();
        out.print("<p style='color:red'>Error al cargar datos.</p>");
    } finally {
        if (rs   != null) try { rs.close();   } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close();  } catch (Exception ignored) {}
        if (con  != null) try { con.close();   } catch (Exception ignored) {}
    }
%>

</body>
</html>
