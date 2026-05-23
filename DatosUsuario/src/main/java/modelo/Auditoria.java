package modelo;

public class Auditoria {

    private int    id_auditoria;
    private int    idusu;
    private String usuario;
    private String nombre_completo;
    private String accion;
    private String modulo;
    private String descripcion;
    private String ip_address;
    private String fecha;

    public int    getId_auditoria()                      { return id_auditoria; }
    public void   setId_auditoria(int id_auditoria)      { this.id_auditoria = id_auditoria; }

    public int    getIdusu()               { return idusu; }
    public void   setIdusu(int idusu)      { this.idusu = idusu; }

    public String getUsuario()                { return usuario; }
    public void   setUsuario(String usuario)  { this.usuario = usuario; }

    public String getNombre_completo()                         { return nombre_completo; }
    public void   setNombre_completo(String nombre_completo)   { this.nombre_completo = nombre_completo; }

    public String getAccion()               { return accion; }
    public void   setAccion(String accion)  { this.accion = accion; }

    public String getModulo()               { return modulo; }
    public void   setModulo(String modulo)  { this.modulo = modulo; }

    public String getDescripcion()                   { return descripcion; }
    public void   setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getIp_address()                    { return ip_address; }
    public void   setIp_address(String ip_address)   { this.ip_address = ip_address; }

    public String getFecha()              { return fecha; }
    public void   setFecha(String fecha)  { this.fecha = fecha; }
}
