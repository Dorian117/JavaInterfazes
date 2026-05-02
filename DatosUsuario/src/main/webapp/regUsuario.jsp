<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registro de Usuario</title>
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
    <h2>Registro de Usuario</h2>
    <form action="controladorUsuario" method="POST">
        <table>
            <tr>
                <td>Nº Documento:</td>
                <td><input type="text" name="num_docu" maxlength="20" required></td>
            </tr>
            <tr>
                <td>Nombre:</td>
                <td><input type="text" name="nombre" maxlength="30" required></td>
            </tr>
            <tr>
                <td>Apellido:</td>
                <td><input type="text" name="apellido" maxlength="30" required></td>
            </tr>
            <tr>
                <td>Email:</td>
                <td><input type="email" name="email" maxlength="60" required></td>
            </tr>
            <tr>
                <td>Usuario:</td>
                <td><input type="text" name="usuario" maxlength="20" required></td>
            </tr>
            <tr>
                <td>Contraseña:</td>
                <td><input type="password" name="clave" maxlength="8" required></td>
            </tr>
            <tr>
                <td>Perfil:</td>
                <td>
                    <select name="id_perfil" required>
                        <option value="1">Administrador</option>
                        <option value="2">Operador</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" value="Registrar"></td>
            </tr>
        </table>
    </form>
</body>
</html>
