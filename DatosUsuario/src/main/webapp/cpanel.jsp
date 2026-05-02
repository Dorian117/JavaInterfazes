<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="modelo.Conexion, java.sql.*" %>
<%
    // Verificar sesión activa
    String nUsuario = (String) session.getAttribute("nUsuario");
    if (nUsuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    Connection con = null;
    Statement sentencia = null;
    ResultSet resultado = null;
    String nombre   = "";
    String apellido = "";
    String usu      = "";

    // Consulta 1: datos del usuario en sesión
    try {
        Conexion cn = new Conexion();
        con = cn.crearConexion();
        sentencia = con.createStatement();
        resultado = sentencia.executeQuery(
            "SELECT * FROM usuarios WHERE usuario = '" + nUsuario + "'"
        );
        if (resultado.next()) {
            nombre   = resultado.getString("nombre");
            apellido = resultado.getString("apellido");
            usu      = resultado.getString("usuario");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (resultado  != null) try { resultado.close();  } catch (Exception ignored) {}
        if (sentencia  != null) try { sentencia.close();  } catch (Exception ignored) {}
        if (con        != null) try { con.close();        } catch (Exception ignored) {}
    }

    // Consulta 2: actividades del perfil del usuario
    Connection con2 = null;
    Statement  sentencia2 = null;
    ResultSet  resultado2 = null;
    try {
        Conexion cn2 = new Conexion();
        con2 = cn2.crearConexion();
        sentencia2 = con2.createStatement();
        resultado2 = sentencia2.executeQuery(
            "SELECT actividades.nom_actividad AS actividad, " +
            "       actividades.id_actividad  AS idAct, " +
            "       actividades.enlace        AS enlace " +
            "FROM usuarios, actividades, gesactividad, perfiles " +
            "WHERE gesactividad.id_actividad = actividades.id_actividad " +
            "  AND gesactividad.id_perfil    = perfiles.id_perfil " +
            "  AND usuarios.id_perfil        = perfiles.id_perfil " +
            "  AND usuarios.usuario          = '" + nUsuario + "'"
        );
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Panel de Control</title>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; }

        #apDiv6 {
            position: absolute; left: 0; top: 0;
            width: 100%; height: 50px;
            background: #4a90d9; color: #fff;
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 20px; box-sizing: border-box;
        }
        #apDiv6 a { color: #fff; text-decoration: none; font-weight: bold; }
        #apDiv6 a:hover { text-decoration: underline; }

        #apDiv5 {
            position: absolute; left: 0; top: 50px;
            width: 200px; bottom: 0;
            background: #e8e8e8; overflow-y: auto;
            padding: 10px 0;
        }
        #apDiv5 table { width: 100%; border-collapse: collapse; }
        #apDiv5 th {
            background: #4a90d9; color: #fff;
            padding: 8px; text-align: left;
        }
        #apDiv5 td { padding: 6px 10px; }
        #apDiv5 td a { text-decoration: none; color: #333; display: block; }
        #apDiv5 td a:hover { background: #d0d0d0; }

        #apDiv7 {
            position: absolute; left: 200px; top: 50px;
            right: 0; bottom: 0;
        }
        #apDiv7 iframe { width: 100%; height: 100%; border: none; }
    </style>
</head>
<body>

<!-- apDiv6: cabecera con usuario y logout -->
<div id="apDiv6">
    <span>Bienvenido: <strong><%= nombre %> <%= apellido %></strong></span>
    <a href="cerrarSesion">Cerrar sesión</a>
</div>

<!-- apDiv5: menú lateral con actividades del perfil -->
<div id="apDiv5">
    <table>
        <tr><th>Menú</th></tr>
        <%
            while (resultado2.next()) {
                String actividad = resultado2.getString("actividad");
                String enlace    = resultado2.getString("enlace");
                int    idAct     = resultado2.getInt("idAct");
        %>
        <tr>
            <td><a href="<%= enlace %>?id=<%= idAct %>" target="marco"><%= actividad %></a></td>
        </tr>
        <%
            }
        %>
    </table>
</div>

<!-- apDiv7: área de contenido principal -->
<div id="apDiv7">
    <iframe name="marco" src="front.jsp"></iframe>
</div>

</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (resultado2  != null) try { resultado2.close();  } catch (Exception ignored) {}
        if (sentencia2  != null) try { sentencia2.close();  } catch (Exception ignored) {}
        if (con2        != null) try { con2.close();        } catch (Exception ignored) {}
    }
%>
