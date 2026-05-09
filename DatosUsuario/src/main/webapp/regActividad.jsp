<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="modelo.Conexion, java.sql.*" %>
<%
    String nUsuario = (String) session.getAttribute("nUsuario");
    if (nUsuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registro de Actividad</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; color: #333; }
        h2, h3 { color: #4a90d9; }
        .seccion { background: #f9f9f9; border: 1px solid #ddd; border-radius: 6px;
                   padding: 16px 20px; margin-bottom: 24px; max-width: 500px; }
        .form-fila { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }
        .form-fila label { font-weight: bold; min-width: 160px; }
        input[type=text] { padding: 7px; border: 1px solid #ccc; border-radius: 4px; width: 220px; }
        input[type=submit] {
            padding: 8px 20px; background: #4a90d9; color: #fff;
            border: none; border-radius: 4px; cursor: pointer; font-size: 14px;
        }
        input[type=submit]:hover { background: #357abd; }
        table { border-collapse: collapse; width: 100%; }
        th { background: #4a90d9; color: #fff; padding: 8px 12px; text-align: left; }
        td { padding: 7px 12px; border-bottom: 1px solid #ddd; }
        tr:hover td { background: #f0f6ff; }
    </style>
</head>
<body>

<h2>Registro de Nueva Actividad</h2>

<div class="seccion">
    <form action="controladorActividad?accion=registrar" method="POST">
        <div class="form-fila">
            <label for="nom_actividad">Nombre de la actividad:</label>
            <input type="text" id="nom_actividad" name="nom_actividad"
                   maxlength="45" required placeholder="Ej: Reporte Ventas">
        </div>
        <div class="form-fila">
            <label for="enlace">Enlace (archivo .jsp):</label>
            <input type="text" id="enlace" name="enlace"
                   maxlength="100" required placeholder="nombreArchivo.jsp">
        </div>
        <input type="submit" value="Registrar Actividad">
    </form>
</div>

<h3>Actividades registradas</h3>
<%
    Connection con = null;
    Statement stmt = null;
    ResultSet rs   = null;
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
        </tr>
    </thead>
    <tbody>
        <% while (rs.next()) { %>
        <tr>
            <td><%= rs.getInt("id_actividad") %></td>
            <td><%= rs.getString("nom_actividad") %></td>
            <td><%= rs.getString("enlace") %></td>
        </tr>
        <% } %>
    </tbody>
</table>
<%
    } catch (Exception e) {
        e.printStackTrace();
        out.print("<p style='color:red'>Error al cargar actividades.</p>");
    } finally {
        if (rs   != null) try { rs.close();   } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close();  } catch (Exception ignored) {}
        if (con  != null) try { con.close();   } catch (Exception ignored) {}
    }
%>

</body>
</html>
