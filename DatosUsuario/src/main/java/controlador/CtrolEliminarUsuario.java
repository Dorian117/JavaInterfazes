package controlador;

import modelo.AuditoriaUtil;
import modelo.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ctrolEliminarUsuario")
public class CtrolEliminarUsuario extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nUsuario = (String) request.getSession(false).getAttribute("nUsuario");
        String idStr = request.getParameter("id");
        int id = Integer.parseInt(idStr);

        new UsuarioDAO().eliminar(id);

        AuditoriaUtil.registrar(request, nUsuario,
            "ELIMINAR", "USUARIO", "Usuario eliminado: ID " + idStr);

        response.sendRedirect("listarUsuarios.jsp");
    }
}
