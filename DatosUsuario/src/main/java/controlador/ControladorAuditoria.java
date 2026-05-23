package controlador;

import modelo.AuditoriaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet("/controladorAuditoria")
public class ControladorAuditoria extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nUsuario = (String) request.getSession(false) != null
            ? (String) request.getSession(false).getAttribute("nUsuario") : null;
        if (nUsuario == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        if ("limpiar".equals(accion)) {
            // Eliminar registros anteriores a 30 días
            LocalDate limite = LocalDate.now().minusDays(30);
            String fechaLimite = limite.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + " 00:00:00";
            new AuditoriaDAO().eliminarAnterioresA(fechaLimite);
        }
        response.sendRedirect("auditoria.jsp");
    }
}
