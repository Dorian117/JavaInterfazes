package controlador;

import modelo.AuditoriaUtil;
import modelo.Usuario;
import modelo.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/controladorUsuario")
public class ControladorUsuario extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String nUsuario = (String) request.getSession(false).getAttribute("nUsuario");

        Usuario u = new Usuario();
        u.setNum_docu(request.getParameter("num_docu"));
        u.setNombre(request.getParameter("nombre"));
        u.setApellido(request.getParameter("apellido"));
        u.setEmail(request.getParameter("email"));
        String usuario = request.getParameter("usuario");
        u.setUsuario(usuario);
        u.setClave(request.getParameter("clave"));
        u.setId_perfil(Integer.parseInt(request.getParameter("id_perfil")));

        new UsuarioDAO().insertar(u);

        AuditoriaUtil.registrar(request, nUsuario,
            "CREAR", "USUARIO", "Usuario creado: " + usuario);

        response.sendRedirect("listarUsuarios.jsp");
    }
}
