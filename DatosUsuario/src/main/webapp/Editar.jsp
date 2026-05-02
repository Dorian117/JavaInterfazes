<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="modelo.UsuarioDAO, modelo.Usuario" %>
<%
    String nUsuario = (String) session.getAttribute("nUsuario");
    if (nUsuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    int id = Integer.parseInt(request.getParameter("id"));
    Usuario u = new UsuarioDAO().buscar(id);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Usuario</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; color: #333; }
        h2 { color: #4a90d9; }
        table { border-collapse: collapse; }
        td { padding: 6px 10px; }
        td:first-child { text-align: right; font-weight: bold; }
        input[type=text], input[type=email], input[type=password], select {
            padding: 6px; border: 1px solid #ccc; border-radius: 4px; width: 220px; }
        input[type=submit] {
            padding: 8px 20px; background: #4a90d9; color: #fff;
            border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
        input[type=submit]:hover { background: #357abd; }
    </style>
</head>
<body>
    <h2>Editar Usuario</h2>
    <form action="ctrolEditarUsuario" method="POST">
        <input type="hidden" name="idusu" value="<%= u.getIdusu() %>">
        <table>
            <tr>
                <td>Nº Documento:</td>
                <td><input type="text" name="num_docu" maxlength="20"
                           value="<%= u.getNum_docu() %>" required></td>
            </tr>
            <tr>
                <td>Nombre:</td>
                <td><input type="text" name="nombre" maxlength="30"
                           value="<%= u.getNombre() %>" required></td>
            </tr>
            <tr>
                <td>Apellido:</td>
                <td><input type="text" name="apellido" maxlength="30"
                           value="<%= u.getApellido() %>" required></td>
            </tr>
            <tr>
                <td>Email:</td>
                <td><input type="email" name="email" maxlength="60"
                           value="<%= u.getEmail() %>" required></td>
            </tr>
            <tr>
                <td>Usuario:</td>
                <td><input type="text" name="usuario" maxlength="20"
                           value="<%= u.getUsuario() %>" required></td>
            </tr>
            <tr>
                <td>Contraseña:</td>
                <td><input type="password" name="clave" maxlength="8"
                           value="<%= u.getClave() %>" required></td>
            </tr>
            <tr>
                <td>Perfil:</td>
                <td>
                    <select name="id_perfil" required>
                        <option value="1" <%= u.getId_perfil() == 1 ? "selected" : "" %>>Administrador</option>
                        <option value="2" <%= u.getId_perfil() == 2 ? "selected" : "" %>>Operador</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" value="Actualizar"></td>
            </tr>
        </table>
    </form>
</body>
</html>
