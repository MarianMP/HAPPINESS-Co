package happiness.co;

import java.util.*;

public class HappinessCo {

    private static final GestionSistema sistema = new GestionSistema();
    private static final Scanner sc = new Scanner(System.in);

    public static void main(String[] args) {
        int opcion;
        do {
            mostrarMenu();
            opcion = leerEntero("Seleccione una opcion: ");

            switch (opcion) {
                case 1: añadirUsuario(); break;
                case 2: eliminarUsuario(); break;
                case 3: añadirEvento(); break;
                case 4: eliminarEvento(); break;
                case 5: añadirGaleria(); break;
                case 6: eliminarGaleria(); break;
                case 7: añadirFavorito(); break;
                case 8: eliminarFavorito(); break;
                case 9: System.out.println("Saliendo del sistema."); break;
                default: System.out.println("Opcion no valida.");
            }
        } while (opcion != 9);
    }

    private static void mostrarMenu() {
        System.out.println("\n-----------------------------------------");
        System.out.println("   SISTEMA DE GESTION - HAPPINESS&CO   ");
        System.out.println("-----------------------------------------");
        System.out.println(" 1. Registrar Nuevo Usuario");
        System.out.println(" 2. Eliminar Usuario ");
        System.out.println(" 3. Crear Nuevo Evento");
        System.out.println(" 4. Eliminar Evento ");
        System.out.println(" 5. Añadir Galeria a un Evento");
        System.out.println(" 6. Eliminar Galeria de un Evento");
        System.out.println(" 7. Añadir Evento a Favoritos");
        System.out.println(" 8. Eliminar de Favoritos");
        System.out.println(" 9. Salir");
        System.out.println("-----------------------------------------");
    }

    private static void añadirUsuario() {
        System.out.println("\n--- ALTA DE USUARIO ---");
        System.out.print("Nombre: "); String n = sc.nextLine();
        System.out.print("Email: "); String e = sc.nextLine();
        System.out.print("Contraseña: "); String p = sc.nextLine();
        System.out.println(sistema.registrarUsuario(n, e, p));
    }

    private static void eliminarUsuario() {
        System.out.println("\n--- LISTADO DE USUARIOS ---");
        if (sistema.listarUsuarios()) {
            System.out.print("Introduzca el Email del usuario a eliminar: ");
            System.out.println(sistema.borrarUsuario(sc.nextLine()));
        }
    }

    private static void añadirEvento() {
        System.out.println("\n--- ALTA DE EVENTO ---");
        System.out.print("Fecha: "); String f = sc.nextLine();
        System.out.print("Titulo: "); String t = sc.nextLine();
        System.out.print("Ubicacion: "); String u = sc.nextLine();
        System.out.print("Descripcion: "); String d = sc.nextLine();
        System.out.println(sistema.registrarEvento(f, t, u, d));
    }

    private static void eliminarEvento() {
        System.out.println("\n--- LISTADO DE EVENTOS ---");
        if (sistema.listarEventos()) {
            int id = leerEntero("ID del evento a eliminar: ");
            System.out.println(sistema.borrarEvento(id));
        }
    }

    private static void añadirGaleria() {
        System.out.println("\n--- SELECCION DE EVENTO ---");
        if (sistema.listarEventos()) {
            int idEv = leerEntero("ID del evento para la galeria: ");
            System.out.print("Titulo de la galeria: ");
            String tit = sc.nextLine();
            System.out.println(sistema.registrarGaleria(idEv, tit));
        }
    }

    private static void eliminarGaleria() {
        System.out.println("\n--- SELECCION DE EVENTO ---");
        if (sistema.listarEventos()) {
            int idEv = leerEntero("ID del evento: ");
            if (sistema.existeEvento(idEv)) {
                System.out.println("\n--- GALERIAS DISPONIBLES ---");
                sistema.listarGaleriasDeEvento(idEv);
                int idGal = leerEntero("ID de la galeria a eliminar: ");
                System.out.println(sistema.borrarGaleria(idEv, idGal));
            } else {
                System.out.println("Error: El ID de evento no existe.");
            }
        }
    }

    private static void añadirFavorito() {
        System.out.println("\n--- REGISTRO DE FAVORITO ---");
        sistema.listarEventos();
        System.out.println("-------------------------");
        sistema.listarUsuarios();
        int idEv = leerEntero("ID Evento: ");
        System.out.print("Email Usuario: "); String email = sc.nextLine();
        System.out.println(sistema.registrarFavorito(email, idEv));
    }

    private static void eliminarFavorito() {
        System.out.println("\n--- LISTADO DE FAVORITOS ---");
        if (sistema.listarFavoritos()) {
            int idEv = leerEntero("ID Evento del favorito: ");
            System.out.print("Email Usuario del favorito: "); String email = sc.nextLine();
            System.out.println(sistema.borrarFavorito(email, idEv));
        }
    }

    private static int leerEntero(String mensaje) {
        System.out.print(mensaje);
        while (!sc.hasNextInt()) {
            System.out.print("Error: Introduzca un numero entero: ");
            sc.next();
        }
        int num = sc.nextInt();
        sc.nextLine(); 
        return num;
    }
}

class GestionSistema {
    private HashMap<String, Usuario> usuarios = new HashMap<>();
    private HashMap<Integer, Evento> eventos = new HashMap<>();
    private ArrayList<Favorito> favoritos = new ArrayList<>();
    private int contEv = 0;
    private int contGal = 0;

    public String registrarUsuario(String n, String e, String p) {
        if (usuarios.containsKey(e)) return "El usuario ya existe.";
        usuarios.put(e, new Usuario(n, e, p));
        return "Usuario creado correctamente.";
    }

    public String borrarUsuario(String email) {
        return (usuarios.remove(email) != null) ? "Usuario eliminado correctamente." : "El usuario no existe.";
    }

    public String registrarEvento(String f, String t, String u, String d) {
        eventos.put(contEv, new Evento(contEv, f, t, u, d));
        return "Evento creado con ID: " + (contEv++);
    }

    public String borrarEvento(int id) {
        return (eventos.remove(id) != null) ? "Evento eliminado correctamente." : "El evento no existe.";
    }

    public String registrarGaleria(int idEv, String tit) {
        Evento ev = eventos.get(idEv);
        if (ev == null) return "Error: Evento no encontrado.";
        ev.getGalerias().add(new Galeria(contGal++, tit, idEv));
        return "Galeria creada correctamente.";
    }

    public String borrarGaleria(int idEv, int idGal) {
        Evento ev = eventos.get(idEv);
        if (ev == null) return "Error: Evento no encontrado.";
        boolean ok = ev.getGalerias().removeIf(g -> g.getId() == idGal);
        return ok ? "Galeria eliminada correctamente." : "La galeria no existe.";
    }

    public String registrarFavorito(String email, int idEv) {
        if (!usuarios.containsKey(email) || !eventos.containsKey(idEv)) return "Error: Datos incorrectos.";
        favoritos.add(new Favorito(email, idEv));
        return "Favorito creado correctamente.";
    }

    public String borrarFavorito(String email, int idEv) {
        boolean ok = favoritos.removeIf(f -> f.getCorreoUsuario().equals(email) && f.getIdEvento() == idEv);
        return ok ? "Favorito eliminado correctamente." : "El favorito no existe.";
    }

    public boolean listarEventos() {
        if (eventos.isEmpty()) { System.out.println("No hay eventos registrados."); return false; }
        eventos.values().forEach(System.out::println); return true;
    }
    public boolean listarUsuarios() {
        if (usuarios.isEmpty()) { System.out.println("No hay usuarios registrados."); return false; }
        usuarios.values().forEach(System.out::println); return true;
    }
    public boolean listarFavoritos() {
        if (favoritos.isEmpty()) { System.out.println("No hay favoritos registrados."); return false; }
        favoritos.forEach(System.out::println); return true;
    }
    public void listarGaleriasDeEvento(int id) {
        if (eventos.get(id).getGalerias().isEmpty()) System.out.println("Este evento no tiene galerias.");
        else eventos.get(id).getGalerias().forEach(System.out::println);
    }
    public boolean existeEvento(int id) { return eventos.containsKey(id); }
}

class Usuario {
    private String nombre, email, password;
    public Usuario(String n, String e, String p) { this.nombre = n; this.email = e; this.password = p; }
    @Override public String toString() { return "Usuario: " + nombre + " | Email: " + email; }
}

class Evento {
    private int id;
    private String fecha, titulo, ubicacion, descripcion;
    private ArrayList<Galeria> galerias = new ArrayList<>();
    public Evento(int i, String f, String t, String u, String d) { this.id = i; this.fecha = f; this.titulo = t; this.ubicacion = u; this.descripcion = d; }
    public int getId() { return id; }
    public ArrayList<Galeria> getGalerias() { return galerias; }
    @Override public String toString() { return "ID: " + id + " | Titulo: " + titulo + " | Fecha: " + fecha; }
}

class Galeria {
    private int id, idEvento;
    private String titulo;
    public Galeria(int i, String t, int ie) { this.id = i; this.titulo = t; this.idEvento = ie; }
    public int getId() { return id; }
    @Override public String toString() { return "   Galeria ID: " + id + " | Titulo: " + titulo; }
}

class Favorito {
    private String correoUsuario;
    private int idEvento;
    public Favorito(String c, int i) { this.correoUsuario = c; this.idEvento = i; }
    public String getCorreoUsuario() { return correoUsuario; }
    public int getIdEvento() { return idEvento; }
    @Override public String toString() { return "Favorito -> Usuario: " + correoUsuario + " | ID Evento: " + idEvento; }
}