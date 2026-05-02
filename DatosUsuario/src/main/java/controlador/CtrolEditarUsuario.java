package controlador;

import modelo.Usuario;
import modelo.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ctrolEditarUsuario")
public class CtrolEditarUsuario extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Usuario u = new Usuario();
        u.setIdusu(Integer.parseInt(request.getParameter("idusu")));
        u.setNum_docu(request.getParameter("num_docu"));
        u.setNombre(request.getParameter("nombre"));
        u.setApellido(request.getParameter("apellido"));
        u.setEmail(request.getParameter("email"));
        u.setUsuario(request.getParameter("usuario"));
        u.setClave(request.getParameter("clave"));
        u.setId_perfil(Integer.parseInt(request.getParameter("id_perfil")));

        new UsuarioDAO().actualizar(u);

        response.sendRedirect("listarUsuarios.jsp");
    }
}
