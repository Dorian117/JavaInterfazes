package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PerfilDAO {

    public List<Perfil> listarPerfiles() {
        List<Perfil> lista = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs   = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.createStatement();
            rs   = stmt.executeQuery("SELECT * FROM perfiles ORDER BY id_perfil");
            while (rs.next()) {
                Perfil p = new Perfil();
                p.setId_perfil(rs.getInt("id_perfil"));
                p.setPerfil(rs.getString("perfil"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrar(rs, stmt, con);
        }
        return lista;
    }

    /** Inserta un perfil y retorna el id generado, o -1 si falla. */
    public int insertarPerfil(String nombrePerfil) {
        Connection con   = null;
        PreparedStatement stmt = null;
        ResultSet rs     = null;
        int idGenerado   = -1;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement(
                "INSERT INTO perfiles (perfil) VALUES (?)",
                Statement.RETURN_GENERATED_KEYS
            );
            stmt.setString(1, nombrePerfil);
            stmt.executeUpdate();
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                idGenerado = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrar(rs, stmt, con);
        }
        return idGenerado;
    }

    public Perfil buscarPerfil(int id) {
        Perfil p  = null;
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs  = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement("SELECT * FROM perfiles WHERE id_perfil = ?");
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            if (rs.next()) {
                p = new Perfil();
                p.setId_perfil(rs.getInt("id_perfil"));
                p.setPerfil(rs.getString("perfil"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrar(rs, stmt, con);
        }
        return p;
    }

    /**
     * Elimina un perfil solo si no tiene usuarios asignados.
     * Retorna true si se eliminó, false si tiene usuarios.
     */
    public boolean eliminarPerfil(int id) {
        Connection con = null;
        PreparedStatement check = null;
        PreparedStatement del   = null;
        ResultSet rs = null;
        try {
            con   = new Conexion().crearConexion();
            check = con.prepareStatement(
                "SELECT COUNT(*) FROM usuarios WHERE id_perfil = ?"
            );
            check.setInt(1, id);
            rs = check.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false; // tiene usuarios asignados
            }
            rs.close();
            check.close();

            // Eliminar gesactividad asociada antes de borrar el perfil
            del = con.prepareStatement("DELETE FROM gesactividad WHERE id_perfil = ?");
            del.setInt(1, id);
            del.executeUpdate();
            del.close();

            del = con.prepareStatement("DELETE FROM perfiles WHERE id_perfil = ?");
            del.setInt(1, id);
            del.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (rs    != null) rs.close();    } catch (Exception ignored) {}
            try { if (check != null) check.close(); } catch (Exception ignored) {}
            try { if (del   != null) del.close();   } catch (Exception ignored) {}
            try { if (con   != null) con.close();   } catch (Exception ignored) {}
        }
    }

    /**
     * Reemplaza todas las actividades asignadas a un perfil.
     * Si idsActividades está vacío, solo elimina las existentes.
     */
    public void asignarActividades(int idPerfil, int[] idsActividades) {
        Connection con = null;
        PreparedStatement del  = null;
        PreparedStatement ins  = null;
        try {
            con = new Conexion().crearConexion();
            con.setAutoCommit(false);

            del = con.prepareStatement("DELETE FROM gesactividad WHERE id_perfil = ?");
            del.setInt(1, idPerfil);
            del.executeUpdate();

            if (idsActividades != null && idsActividades.length > 0) {
                ins = con.prepareStatement(
                    "INSERT INTO gesactividad (id_perfil, id_actividad) VALUES (?, ?)"
                );
                for (int idAct : idsActividades) {
                    ins.setInt(1, idPerfil);
                    ins.setInt(2, idAct);
                    ins.addBatch();
                }
                ins.executeBatch();
            }

            con.commit();
        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ignored) {}
        } finally {
            try { if (ins != null) ins.close(); } catch (Exception ignored) {}
            try { if (del != null) del.close(); } catch (Exception ignored) {}
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (Exception ignored) {}
        }
    }

    public List<Integer> obtenerActividadesDePerfil(int idPerfil) {
        List<Integer> ids = new ArrayList<>();
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs   = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement(
                "SELECT id_actividad FROM gesactividad WHERE id_perfil = ?"
            );
            stmt.setInt(1, idPerfil);
            rs = stmt.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("id_actividad"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrar(rs, stmt, con);
        }
        return ids;
    }

    public List<Actividad> listarActividades() {
        List<Actividad> lista = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs   = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.createStatement();
            rs   = stmt.executeQuery("SELECT * FROM actividades ORDER BY id_actividad");
            while (rs.next()) {
                Actividad a = new Actividad();
                a.setId_actividad(rs.getInt("id_actividad"));
                a.setNom_actividad(rs.getString("nom_actividad"));
                a.setEnlace(rs.getString("enlace"));
                lista.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrar(rs, stmt, con);
        }
        return lista;
    }

    private void cerrar(ResultSet rs, Statement stmt, Connection con) {
        try { if (rs   != null) rs.close();   } catch (Exception ignored) {}
        try { if (stmt != null) stmt.close();  } catch (Exception ignored) {}
        try { if (con  != null) con.close();   } catch (Exception ignored) {}
    }
}
