package modelo;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {

    private static final String URL  = "jdbc:mysql://localhost:3306/datosusuario";
    private static final String USER = "root";
    // IMPORTANTE: cambia esta contraseña por la que configuraste al instalar MySQL
    private static final String PASS = "admin";

    public Connection crearConexion() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
