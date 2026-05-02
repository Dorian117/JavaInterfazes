package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LoginDAO {

    public Usuario Login_datos(String usuario, String clave) {
        Usuario datos = null;
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Conexion cn = new Conexion();
            con  = cn.crearConexion();
            stmt = con.prepareStatement(
                "SELECT * FROM usuarios WHERE usuario = ? AND clave = ?"
            );
            stmt.setString(1, usuario);
            stmt.setString(2, clave);
            rs = stmt.executeQuery();
            if (rs.next()) {
                datos = new Usuario();
                datos.setUsuario(rs.getString("usuario"));
                datos.setClave(rs.getString("clave"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs   != null) rs.close();   } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close();  } catch (Exception ignored) {}
            try { if (con  != null) con.close();   } catch (Exception ignored) {}
        }
        return datos;
    }
}
