package controlador;

import modelo.AuditoriaUtil;
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

        String accion   = request.getParameter("accion");
        String nUsuario = (String) request.getSession(false).getAttribute("nUsuario");
        PerfilDAO dao   = new PerfilDAO();

        if (accion == null) {
            response.sendRedirect("gestionRoles.jsp");
            return;
        }

        switch (accion) {

            case "crear": {
                String nombrePerfil  = request.getParameter("nombrePerfil");
                int[]  idsActividades = parsearActividades(request);

                int idPerfil = dao.insertarPerfil(nombrePerfil);
                if (idPerfil > 0) {
                    dao.asignarActividades(idPerfil, idsActividades);
                }
                AuditoriaUtil.registrar(request, nUsuario,
                    "CREAR", "ROL", "Rol creado: " + nombrePerfil);
                response.sendRedirect("gestionRoles.jsp");
                break;
            }

            case "editar": {
                String idPerfilStr   = request.getParameter("idPerfil");
                int    idPerfil      = Integer.parseInt(idPerfilStr);
                int[]  idsActividades = parsearActividades(request);
                dao.asignarActividades(idPerfil, idsActividades);
                AuditoriaUtil.registrar(request, nUsuario,
                    "EDITAR", "ROL", "Permisos editados del rol ID: " + idPerfilStr);
                response.sendRedirect("gestionRoles.jsp");
                break;
            }

            case "eliminar": {
                String idPerfilStr = request.getParameter("idPerfil");
                int    idPerfil    = Integer.parseInt(idPerfilStr);
                boolean eliminado  = dao.eliminarPerfil(idPerfil);
                if (eliminado) {
                    AuditoriaUtil.registrar(request, nUsuario,
                        "ELIMINAR", "ROL", "Rol eliminado: ID " + idPerfilStr);
                    response.sendRedirect("gestionRoles.jsp");
                } else {
                    response.sendRedirect("gestionRoles.jsp?error=tieneUsuarios&idPerfil=" + idPerfil);
                }
                break;
            }

            default:
                response.sendRedirect("gestionRoles.jsp");
        }
    }

    private int[] parsearActividades(HttpServletRequest request) {
        String[] valores = request.getParameterValues("actividades[]");
        if (valores == null || valores.length == 0) return new int[0];
        int[] ids = new int[valores.length];
        for (int i = 0; i < valores.length; i++) ids[i] = Integer.parseInt(valores[i]);
        return ids;
    }
}
