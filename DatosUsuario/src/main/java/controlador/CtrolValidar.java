package controlador;

import modelo.AuditoriaUtil;
import modelo.LoginDAO;
import modelo.Usuario;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ctrolValidar")
public class CtrolValidar extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cusuario = request.getParameter("cusuario");
        String cclave   = request.getParameter("cclave");
        String accion   = request.getParameter("accion");

        if (accion != null && accion.equalsIgnoreCase("Ingresar")) {
            LoginDAO dao  = new LoginDAO();
            Usuario datos = dao.Login_datos(cusuario, cclave);

            if (datos != null && datos.getUsuario() != null) {
                HttpSession sesion_cli = request.getSession(true);
                sesion_cli.setAttribute("nUsuario", cusuario);
                AuditoriaUtil.registrar(request, cusuario,
                    "LOGIN", "SISTEMA", "Inicio de sesión exitoso");
                RequestDispatcher rd = request.getRequestDispatcher("cpanel.jsp");
                rd.forward(request, response);
            } else {
                AuditoriaUtil.registrar(request, cusuario,
                    "LOGIN", "SISTEMA", "Intento de login fallido");
                RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
                rd.forward(request, response);
            }
        } else {
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
            rd.forward(request, response);
        }
    }
}
