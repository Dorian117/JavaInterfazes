package controlador;

import modelo.AuditoriaUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/cerrarSesion")
public class CerrarSesion extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion_cli = request.getSession(false);
        if (sesion_cli != null) {
            String nUsuario = (String) sesion_cli.getAttribute("nUsuario");
            if (nUsuario != null) {
                AuditoriaUtil.registrar(request, nUsuario,
                    "LOGOUT", "SISTEMA", "Cierre de sesión");
            }
            sesion_cli.invalidate();
        }
        response.sendRedirect("index.jsp");
    }
}
