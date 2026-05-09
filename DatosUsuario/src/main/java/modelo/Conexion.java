package modelo;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {

    private static final String URL  = "jdbc:mysql://127.0.0.1:3306/datosusuario";
    private static final String USER = "root";
    // XAMPP: contraseña vacía por defecto. Cámbiala si configuraste una distinta.
    private static final String PASS = "";

    public Connection crearConexion() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
