package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public List<Usuario> listar() {
        List<Usuario> lista = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs   = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.createStatement();
            rs   = stmt.executeQuery("SELECT * FROM usuarios");
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdusu(rs.getInt("idusu"));
                u.setNum_docu(rs.getString("num_docu"));
                u.setNombre(rs.getString("nombre"));
                u.setApellido(rs.getString("apellido"));
                u.setEmail(rs.getString("email"));
                u.setUsuario(rs.getString("usuario"));
                u.setClave(rs.getString("clave"));
                u.setId_perfil(rs.getInt("id_perfil"));
                lista.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs   != null) rs.close();   } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close();  } catch (Exception ignored) {}
            try { if (con  != null) con.close();   } catch (Exception ignored) {}
        }
        return lista;
    }

    public void insertar(Usuario u) {
        Connection con   = null;
        PreparedStatement stmt = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement(
                "INSERT INTO usuarios (num_docu, nombre, apellido, email, usuario, clave, id_perfil) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            stmt.setString(1, u.getNum_docu());
            stmt.setString(2, u.getNombre());
            stmt.setString(3, u.getApellido());
            stmt.setString(4, u.getEmail());
            stmt.setString(5, u.getUsuario());
            stmt.setString(6, u.getClave());
            stmt.setInt(7, u.getId_perfil());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (con  != null) con.close();  } catch (Exception ignored) {}
        }
    }

    public Usuario buscar(int id) {
        Usuario u    = null;
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs  = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement("SELECT * FROM usuarios WHERE idusu = ?");
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            if (rs.next()) {
                u = new Usuario();
                u.setIdusu(rs.getInt("idusu"));
                u.setNum_docu(rs.getString("num_docu"));
                u.setNombre(rs.getString("nombre"));
                u.setApellido(rs.getString("apellido"));
                u.setEmail(rs.getString("email"));
                u.setUsuario(rs.getString("usuario"));
                u.setClave(rs.getString("clave"));
                u.setId_perfil(rs.getInt("id_perfil"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs   != null) rs.close();   } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close();  } catch (Exception ignored) {}
            try { if (con  != null) con.close();   } catch (Exception ignored) {}
        }
        return u;
    }

    public void actualizar(Usuario u) {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement(
                "UPDATE usuarios SET num_docu=?, nombre=?, apellido=?, email=?, " +
                "usuario=?, clave=?, id_perfil=? WHERE idusu=?"
            );
            stmt.setString(1, u.getNum_docu());
            stmt.setString(2, u.getNombre());
            stmt.setString(3, u.getApellido());
            stmt.setString(4, u.getEmail());
            stmt.setString(5, u.getUsuario());
            stmt.setString(6, u.getClave());
            stmt.setInt(7, u.getId_perfil());
            stmt.setInt(8, u.getIdusu());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (con  != null) con.close();  } catch (Exception ignored) {}
        }
    }

    public void eliminar(int id) {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement("DELETE FROM usuarios WHERE idusu = ?");
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (con  != null) con.close();  } catch (Exception ignored) {}
        }
    }
}
