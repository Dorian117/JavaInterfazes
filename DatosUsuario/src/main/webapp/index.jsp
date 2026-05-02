<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inicio de Sesión</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f0f0; display: flex;
               justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: #fff; padding: 30px 40px; border-radius: 8px;
                     box-shadow: 0 2px 8px rgba(0,0,0,.2); width: 300px; }
        h2 { text-align: center; margin-bottom: 20px; color: #333; }
        label { display: block; margin-bottom: 4px; color: #555; }
        input[type=text], input[type=password] {
            width: 100%; padding: 8px; margin-bottom: 14px;
            border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        input[type=submit] {
            width: 100%; padding: 10px; background: #4a90d9; color: #fff;
            border: none; border-radius: 4px; cursor: pointer; font-size: 15px; }
        input[type=submit]:hover { background: #357abd; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Acceso al Sistema</h2>
        <form action="ctrolValidar" method="POST">
            <label for="cusuario">Usuario</label>
            <input type="text" id="cusuario" name="cusuario" required>

            <label for="cclave">Contraseña</label>
            <input type="password" id="cclave" name="cclave" required>

            <input type="submit" name="accion" value="Ingresar">
        </form>
    </div>
</body>
</html>
