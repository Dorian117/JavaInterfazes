package controlador;

import modelo.PerfilDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/controladorPerfil")
public class ControladorPerfil extends HttpServlet {

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
        PerfilDAO dao = new PerfilDAO();

        if (accion == null) {
            response.sendRedirect("gestionRoles.jsp");
            return;
        }

        switch (accion) {

            case "crear": {
                String nombrePerfil = request.getParameter("nombrePerfil");
                int[] idsActividades = parsearActividades(request);

                int idPerfil = dao.insertarPerfil(nombrePerfil);
                if (idPerfil > 0) {
                    dao.asignarActividades(idPerfil, idsActividades);
                }
                response.sendRedirect("gestionRoles.jsp");
                break;
            }

            case "editar": {
                int idPerfil = Integer.parseInt(request.getParameter("idPerfil"));
                int[] idsActividades = parsearActividades(request);
                dao.asignarActividades(idPerfil, idsActividades);
                response.sendRedirect("gestionRoles.jsp");
                break;
            }

            case "eliminar": {
                int idPerfil = Integer.parseInt(request.getParameter("idPerfil"));
                boolean eliminado = dao.eliminarPerfil(idPerfil);
                if (eliminado) {
                    response.sendRedirect("gestionRoles.jsp");
                } else {
                    // Perfil tiene usuarios asignados; volver con aviso
                    response.sendRedirect("gestionRoles.jsp?error=tieneUsuarios&idPerfil=" + idPerfil);
                }
                break;
            }

            default:
                response.sendRedirect("gestionRoles.jsp");
        }
    }

    /** Convierte los valores del checkbox "actividades[]" en int[]. */
    private int[] parsearActividades(HttpServletRequest request) {
        String[] valores = request.getParameterValues("actividades[]");
        if (valores == null || valores.length == 0) {
            return new int[0];
        }
        int[] ids = new int[valores.length];
        for (int i = 0; i < valores.length; i++) {
            ids[i] = Integer.parseInt(valores[i]);
        }
        return ids;
    }
}
