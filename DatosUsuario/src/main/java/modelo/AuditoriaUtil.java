package modelo;

import jakarta.servlet.http.HttpServletRequest;

public class AuditoriaUtil {

    /**
     * Registra una acción en la tabla auditoria.
     * Si el usuario no existe en la BD (idusu=0), omite el registro
     * para preservar la integridad referencial de la FK.
     */
    public static void registrar(HttpServletRequest request,
                                  String nUsuario,
                                  String accion,
                                  String modulo,
                                  String descripcion) {
        try {
            UsuarioDAO uDao = new UsuarioDAO();
            int idusu = uDao.getIdUsuario(nUsuario);
            if (idusu <= 0) return; // usuario no existe en BD (login de usuario inexistente)

            Usuario u = uDao.buscar(idusu);
            String nombreCompleto = (u != null)
                ? u.getNombre() + " " + u.getApellido()
                : nUsuario;

            String ip = request.getHeader("X-Forwarded-For");
            if (ip == null || ip.isEmpty()) {
                ip = request.getRemoteAddr();
            }

            Auditoria a = new Auditoria();
            a.setIdusu(idusu);
            a.setUsuario(nUsuario);
            a.setNombre_completo(nombreCompleto);
            a.setAccion(accion);
            a.setModulo(modulo);
            a.setDescripcion(descripcion);
            a.setIp_address(ip);
            new AuditoriaDAO().registrar(a);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
