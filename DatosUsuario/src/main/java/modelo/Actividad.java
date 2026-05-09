package modelo;

public class Actividad {

    private int    id_actividad;
    private String nom_actividad;
    private String enlace;

    public int    getId_actividad()                    { return id_actividad; }
    public void   setId_actividad(int id_actividad)    { this.id_actividad = id_actividad; }

    public String getNom_actividad()                       { return nom_actividad; }
    public void   setNom_actividad(String nom_actividad)   { this.nom_actividad = nom_actividad; }

    public String getEnlace()                { return enlace; }
    public void   setEnlace(String enlace)   { this.enlace = enlace; }
}
