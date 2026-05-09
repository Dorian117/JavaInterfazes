package controlador;

import modelo.Conexion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/controladorActividad")
public class ControladorActividad extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        procesar(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesar(request, response);
    }

    private void procesar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            response.sendRedirect("gestActividades.jsp");
            return;
        }

        switch (accion) {

            case "registrar": {
                String nomActividad = request.getParameter("nom_actividad");
                String enlace       = request.getParameter("enlace");
                insertar(nomActividad, enlace);
                response.sendRedirect("gestActividades.jsp");
                break;
            }

            case "eliminar": {
                int id = Integer.parseInt(request.getParameter("id"));
                if (tieneAsignaciones(id)) {
                    response.sendRedirect("gestActividades.jsp?error=asignada&id=" + id);
                } else {
                    eliminar(id);
                    response.sendRedirect("gestActividades.jsp");
                }
                break;
            }

            case "actualizar": {
                int    id           = Integer.parseInt(request.getParameter("id"));
                String nomActividad = request.getParameter("nom_actividad");
                String enlace       = request.getParameter("enlace");
                actualizar(id, nomActividad, enlace);
                response.sendRedirect("gestActividades.jsp");
                break;
            }

            default:
                response.sendRedirect("gestActividades.jsp");
        }
    }

    private void insertar(String nomActividad, String enlace) {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement(
                "INSERT INTO actividades (nom_actividad, enlace) VALUES (?, ?)"
            );
            stmt.setString(1, nomActividad);
            stmt.setString(2, enlace);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrar(stmt, con);
        }
    }

    private void actualizar(int id, String nomActividad, String enlace) {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement(
                "UPDATE actividades SET nom_actividad = ?, enlace = ? WHERE id_actividad = ?"
            );
            stmt.setString(1, nomActividad);
            stmt.setString(2, enlace);
            stmt.setInt(3, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrar(stmt, con);
        }
    }

    private void eliminar(int id) {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement("DELETE FROM actividades WHERE id_actividad = ?");
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrar(stmt, con);
        }
    }

    /** Verifica si la actividad está asignada a algún perfil en gesactividad. */
    private boolean tieneAsignaciones(int id) {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            con  = new Conexion().crearConexion();
            stmt = con.prepareStatement(
                "SELECT COUNT(*) FROM gesactividad WHERE id_actividad = ?"
            );
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return true; // por seguridad, bloquear si hay error
        } finally {
            try { if (rs   != null) rs.close();   } catch (Exception ignored) {}
            cerrar(stmt, con);
        }
    }

    private void cerrar(PreparedStatement stmt, Connection con) {
        try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
        try { if (con  != null) con.close();  } catch (Exception ignored) {}
    }
}
