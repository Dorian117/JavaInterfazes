<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="modelo.Conexion, java.sql.*, java.util.Date, java.text.SimpleDateFormat" %>
<%
    String nUsuario = (String) session.getAttribute("nUsuario");
    if (nUsuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Datos del usuario en sesión
    String nombre   = "";
    String apellido = "";

    Connection conU = null;
    PreparedStatement stmtU = null;
    ResultSet rsU = null;
    try {
        conU  = new Conexion().crearConexion();
        stmtU = conU.prepareStatement("SELECT nombre, apellido FROM usuarios WHERE usuario = ?");
        stmtU.setString(1, nUsuario);
        rsU = stmtU.executeQuery();
        if (rsU.next()) {
            nombre   = rsU.getString("nombre");
            apellido = rsU.getString("apellido");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rsU   != null) try { rsU.close();   } catch (Exception ignored) {}
        if (stmtU != null) try { stmtU.close(); } catch (Exception ignored) {}
        if (conU  != null) try { conU.close();  } catch (Exception ignored) {}
    }

    String fechaHora = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Prueba 20</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; color: #333; }
        h2   { color: #4a90d9; border-bottom: 2px solid #4a90d9; padding-bottom: 6px; }
        h3   { color: #555; margin-top: 24px; }
        .bienvenida {
            background: linear-gradient(135deg, #4a90d9, #357abd);
            color: #fff; padding: 16px 24px; border-radius: 8px;
            margin-bottom: 20px; font-size: 18px;
        }
        .info-box {
            background: #f0f6ff; border: 1px solid #c3d9f5; border-radius: 6px;
            padding: 12px 18px; margin-bottom: 20px; display: inline-block;
        }
        .info-box span { font-weight: bold; color: #4a90d9; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 24px; }
        th { background: #4a90d9; color: #fff; padding: 8px 12px; text-align: left; }
        td { padding: 7px 12px; border-bottom: 1px solid #ddd; }
        tr:hover td { background: #f5f5f5; }
    </style>
</head>
<body>

<div class="bienvenida">
    &#128075; ¡Bienvenido, <strong><%= nombre %> <%= apellido %></strong>!
    Estás conectado como <em><%= nUsuario %></em>.
</div>

<div class="info-box">
    Fecha y hora del servidor: <span><%= fechaHora %></span>
</div>

<h2>Prueba 20 — Panel de Demostración</h2>

<%-- ===== Tabla de usuarios ===== --%>
<h3>Usuarios registrados en el sistema</h3>
<%
    Connection conLU = null;
    Statement  stmtLU = null;
    ResultSet  rsLU   = null;
    try {
        conLU  = new Conexion().crearConexion();
        stmtLU = conLU.createStatement();
        rsLU   = stmtLU.executeQuery("SELECT * FROM usuarios ORDER BY idusu");
%>
<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Documento</th>
            <th>Nombre</th>
            <th>Apellido</th>
            <th>Email</th>
            <th>Usuario</th>
            <th>ID Perfil</th>
        </tr>
    </thead>
    <tbody>
        <% while (rsLU.next()) { %>
        <tr>
            <td><%= rsLU.getInt("idusu") %></td>
            <td><%= rsLU.getString("num_docu") %></td>
            <td><%= rsLU.getString("nombre") %></td>
            <td><%= rsLU.getString("apellido") %></td>
            <td><%= rsLU.getString("email") %></td>
            <td><%= rsLU.getString("usuario") %></td>
            <td><%= rsLU.getInt("id_perfil") %></td>
        </tr>
        <% } %>
    </tbody>
</table>
<%
    } catch (Exception e) {
        e.printStackTrace();
        out.print("<p style='color:red'>Error al cargar usuarios.</p>");
    } finally {
        if (rsLU   != null) try { rsLU.close();   } catch (Exception ignored) {}
        if (stmtLU != null) try { stmtLU.close(); } catch (Exception ignored) {}
        if (conLU  != null) try { conLU.close();  } catch (Exception ignored) {}
    }
%>

<%-- ===== Tabla perfiles con conteo de usuarios ===== --%>
<h3>Perfiles y cantidad de usuarios asignados</h3>
<%
    Connection conP = null;
    Statement  stmtP = null;
    ResultSet  rsP   = null;
    try {
        conP  = new Conexion().crearConexion();
        stmtP = conP.createStatement();
        rsP   = stmtP.executeQuery(
            "SELECT p.id_perfil, p.perfil, COUNT(u.idusu) AS total_usuarios " +
            "FROM perfiles p LEFT JOIN usuarios u ON p.id_perfil = u.id_perfil " +
            "GROUP BY p.id_perfil, p.perfil ORDER BY p.id_perfil"
        );
%>
<table>
    <thead>
        <tr>
            <th>ID Perfil</th>
            <th>Nombre del Perfil</th>
            <th>Cantidad de Usuarios</th>
        </tr>
    </thead>
    <tbody>
        <% while (rsP.next()) { %>
        <tr>
            <td><%= rsP.getInt("id_perfil") %></td>
            <td><%= rsP.getString("perfil") %></td>
            <td><%= rsP.getInt("total_usuarios") %></td>
        </tr>
        <% } %>
    </tbody>
</table>
<%
    } catch (Exception e) {
        e.printStackTrace();
        out.print("<p style='color:red'>Error al cargar perfiles.</p>");
    } finally {
        if (rsP   != null) try { rsP.close();   } catch (Exception ignored) {}
        if (stmtP != null) try { stmtP.close(); } catch (Exception ignored) {}
        if (conP  != null) try { conP.close();  } catch (Exception ignored) {}
    }
%>

</body>
</html>
