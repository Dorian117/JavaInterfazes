package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuditoriaDAO {

    public void registrar(Auditoria a) {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement(
                "INSERT INTO auditoria " +
                "(idusu, usuario, nombre_completo, accion, modulo, descripcion, ip_address) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            stmt.setInt(1, a.getIdusu());
            stmt.setString(2, a.getUsuario());
            stmt.setString(3, a.getNombre_completo());
            stmt.setString(4, a.getAccion());
            stmt.setString(5, a.getModulo());
            stmt.setString(6, a.getDescripcion());
            stmt.setString(7, a.getIp_address());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrar(stmt, con);
        }
    }

    public List<Auditoria> listarTodo() {
        return ejecutarQuery("SELECT * FROM auditoria ORDER BY fecha DESC", new String[0]);
    }

    /**
     * Filtra registros de auditoría. Cualquier parámetro null o vacío se ignora.
     */
    public List<Auditoria> filtrar(String usuario, String accion,
                                    String modulo, String fechaDesde, String fechaHasta) {
        StringBuilder sql = new StringBuilder("SELECT * FROM auditoria WHERE 1=1");
        List<String> params = new ArrayList<>();

        if (usuario != null && !usuario.trim().isEmpty()) {
            sql.append(" AND usuario = ?");
            params.add(usuario.trim());
        }
        if (accion != null && !accion.trim().isEmpty()) {
            sql.append(" AND accion = ?");
            params.add(accion.trim());
        }
        if (modulo != null && !modulo.trim().isEmpty()) {
            sql.append(" AND modulo = ?");
            params.add(modulo.trim());
        }
        if (fechaDesde != null && !fechaDesde.trim().isEmpty()) {
            sql.append(" AND fecha >= ?");
            params.add(fechaDesde.trim());
        }
        if (fechaHasta != null && !fechaHasta.trim().isEmpty()) {
            sql.append(" AND fecha <= ?");
            params.add(fechaHasta.trim() + " 23:59:59");
        }
        sql.append(" ORDER BY fecha DESC");

        return ejecutarQuery(sql.toString(), params.toArray(new String[0]));
    }

    public int contarPorUsuario(int idusu) {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement("SELECT COUNT(*) FROM auditoria WHERE idusu = ?");
            stmt.setInt(1, idusu);
            rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            cerrar(stmt, con);
        }
    }

    public void eliminarAnterioresA(String fecha) {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement("DELETE FROM auditoria WHERE fecha < ?");
            stmt.setString(1, fecha);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrar(stmt, con);
        }
    }

    private List<Auditoria> ejecutarQuery(String sql, String[] params) {
        List<Auditoria> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                stmt.setString(i + 1, params[i]);
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                Auditoria a = new Auditoria();
                a.setId_auditoria(rs.getInt("id_auditoria"));
                a.setIdusu(rs.getInt("idusu"));
                a.setUsuario(rs.getString("usuario"));
                a.setNombre_completo(rs.getString("nombre_completo"));
                a.setAccion(rs.getString("accion"));
                a.setModulo(rs.getString("modulo"));
                a.setDescripcion(rs.getString("descripcion"));
                a.setIp_address(rs.getString("ip_address"));
                Timestamp ts = rs.getTimestamp("fecha");
                a.setFecha(ts != null ? ts.toString().substring(0, 19) : "");
                lista.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            cerrar(stmt, con);
        }
        return lista;
    }

    private void cerrar(Statement stmt, Connection con) {
        try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
        try { if (con  != null) con.close();  } catch (Exception ignored) {}
    }
}
