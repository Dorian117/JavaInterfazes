<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="modelo.UsuarioDAO, modelo.Usuario, java.util.List" %>
<%
    String nUsuario = (String) session.getAttribute("nUsuario");
    if (nUsuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    List<Usuario> lista = new UsuarioDAO().listar();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lista de Usuarios</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; color: #333; }
        h2 { color: #4a90d9; }
        table { border-collapse: collapse; width: 100%; }
        th { background: #4a90d9; color: #fff; padding: 8px 12px; text-align: left; }
        td { padding: 7px 12px; border-bottom: 1px solid #ddd; }
        tr:hover td { background: #f5f5f5; }
        a { color: #4a90d9; text-decoration: none; }
        a:hover { text-decoration: underline; }
        .btn-elim { color: #e74c3c; }
    </style>
</head>
<body>
    <h2>Lista de Usuarios</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Documento</th>
                <th>Nombre</th>
                <th>Apellido</th>
                <th>Email</th>
                <th>Usuario</th>
                <th>Perfil</th>
                <th>Editar</th>
                <th>Eliminar</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Usuario u : lista) {
            %>
            <tr>
                <td><%= u.getIdusu() %></td>
                <td><%= u.getNum_docu() %></td>
                <td><%= u.getNombre() %></td>
                <td><%= u.getApellido() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getUsuario() %></td>
                <td><%= u.getId_perfil() %></td>
                <td><a href="Editar.jsp?id=<%= u.getIdusu() %>">Editar</a></td>
                <td><a class="btn-elim" href="ctrolEliminarUsuario?id=<%= u.getIdusu() %>"
                       onclick="return confirm('¿Eliminar usuario?')">Eliminar</a></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
