<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="modelo.Conexion, java.sql.*" %>
<%
    String nUsuario = (String) session.getAttribute("nUsuario");
    if (nUsuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect("gestActividades.jsp");
        return;
    }
    int id = Integer.parseInt(idParam);

    String nomActividad = "";
    String enlace       = "";

    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        con  = new Conexion().crearConexion();
        stmt = con.prepareStatement("SELECT * FROM actividades WHERE id_actividad = ?");
        stmt.setInt(1, id);
        rs = stmt.executeQuery();
        if (rs.next()) {
            nomActividad = rs.getString("nom_actividad");
            enlace       = rs.getString("enlace");
        } else {
            response.sendRedirect("gestActividades.jsp");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs   != null) try { rs.close();   } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close();  } catch (Exception ignored) {}
        if (con  != null) try { con.close();   } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Actividad</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; color: #333; }
        h2   { color: #4a90d9; border-bottom: 2px solid #4a90d9; padding-bottom: 6px; }
        .seccion { background: #f9f9f9; border: 1px solid #ddd; border-radius: 6px;
                   padding: 16px 20px; max-width: 480px; }
        .form-fila { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; }
        .form-fila label { font-weight: bold; min-width: 160px; }
        input[type=text] { padding: 7px; border: 1px solid #ccc; border-radius: 4px; width: 220px; }
        input[type=submit] {
            padding: 8px 20px; background: #4a90d9; color: #fff;
            border: none; border-radius: 4px; cursor: pointer; font-size: 14px;
        }
        input[type=submit]:hover { background: #357abd; }
        .btn-volver {
            display: inline-block; margin-left: 12px;
            padding: 8px 16px; background: #95a5a6; color: #fff;
            border-radius: 4px; text-decoration: none; font-size: 14px;
        }
        .btn-volver:hover { background: #7f8c8d; }
    </style>
</head>
<body>

<h2>Editar Actividad</h2>

<div class="seccion">
    <form action="controladorActividad?accion=actualizar" method="POST">
        <input type="hidden" name="id" value="<%= id %>">

        <div class="form-fila">
            <label for="nom_actividad">Nombre:</label>
            <input type="text" id="nom_actividad" name="nom_actividad"
                   maxlength="45" required value="<%= nomActividad %>">
        </div>
        <div class="form-fila">
            <label for="enlace">Enlace:</label>
            <input type="text" id="enlace" name="enlace"
                   maxlength="100" required value="<%= enlace %>">
        </div>

        <input type="submit" value="Guardar">
        <a href="gestActividades.jsp" class="btn-volver">Cancelar</a>
    </form>
</div>

</body>
</html>
