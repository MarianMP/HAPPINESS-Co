/* PREPARAR ESQUEMA (Estilo cpr1.sql) */
DROP SCHEMA IF EXISTS GESTION_EVENTOS;
CREATE SCHEMA GESTION_EVENTOS;
USE GESTION_EVENTOS;

/* CREACIÓN DE TABLAS CON CONSTRAINTS */
CREATE TABLE Usuarios (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    CONSTRAINT pk_usuarios PRIMARY KEY (id),
    CONSTRAINT uk_email UNIQUE (email)
);

CREATE TABLE Eventos (
    id INT AUTO_INCREMENT,
    fecha DATE NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    ubicacion VARCHAR(150),
    descripcion TEXT,
    CONSTRAINT pk_eventos PRIMARY KEY (id)
);

CREATE TABLE Galerias (
    id INT AUTO_INCREMENT,
    titulo VARCHAR(100),
    id_evento INT,
    CONSTRAINT pk_galerias PRIMARY KEY (id),
    CONSTRAINT fk_galeria_evento FOREIGN KEY (id_evento) REFERENCES Eventos (id) ON DELETE CASCADE
);

CREATE TABLE Imagenes_Galerias (
    id INT AUTO_INCREMENT,
    titulo VARCHAR(100),
    imagen VARCHAR(255),
    id_galeria INT,
    CONSTRAINT pk_imagenes PRIMARY KEY (id),
    CONSTRAINT fk_imagen_galeria FOREIGN KEY (id_galeria) REFERENCES Galerias (id) ON DELETE CASCADE
);

CREATE TABLE Favoritos (
    id_usuario INT,
    id_evento INT,
    CONSTRAINT pk_favoritos PRIMARY KEY (id_usuario, id_evento),
    CONSTRAINT fk_fav_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios (id),
    CONSTRAINT fk_fav_evento FOREIGN KEY (id_evento) REFERENCES Eventos (id)
);
/* INSERTAR USUARIOS */
INSERT INTO Usuarios (nombre, email, password) VALUES 
('Ana García', 'ana@mail.com', '1234'),
('Luis Torres', 'luis@mail.com', 'abcd'),
('Elena Sanz', 'elena@mail.com', 'qwer');

/* INSERTAR EVENTOS (3 Pasados y 3 Futuros - Hoy es 28-02-2026) */
INSERT INTO Eventos (id, fecha, titulo, ubicacion, descripcion) VALUES 
(1, '2026-01-10', 'Concierto de Jazz', 'Teatro Jovellanos', 'Música bajo las estrellas'),
(2, '2026-01-20', 'Taller Gastronómico', 'Aula Cocina', 'Técnicas culinarias con chefs'),
(3, '2026-02-05', 'Exposición de Pintura', 'Galería Local', 'Arte plástico local'),
(4, '2026-05-22', 'Teatro: La Celestina', 'Escenario Principal', 'Obra de Fernando de Rojas'),
(5, '2026-06-05', 'Expo: Fotografía', 'Sala Social', 'Miradas Urbanas'),
(6, '2026-06-20', 'Festival Rock', 'Recinto Ferial', 'Bandas en directo');

/* INSERTAR GALERÍAS */
INSERT INTO Galerias (id, titulo, id_evento) VALUES 
(1, 'Galeria Jazz', 1), (2, 'Galeria Cocina', 2), (3, 'Galeria Arte', 3);

/* INSERTAR IMÁGENES (Usando tus rutas reales) */
INSERT INTO Imagenes_Galerias (titulo, imagen, id_galeria) VALUES 
('Jazz Pic 1', 'Assets/img/happines-and-co-upper-02.png', 1),
('Jazz Pic 2', 'Assets/img/happines-and-co-propuesta-02.png', 1),
('Jazz Pic 3', 'Assets/img/covadonga.jpg', 1),
('Chef 1', 'Assets/img/happines-and-co-propuesta-06.jpg', 2),
('Chef 2', 'Assets/img/happines-and-co-upper-03.png', 2),
('Chef 3', 'Assets/img/happines-and-co-upper-04.png', 2),
('Arte 1', 'Assets/img/happines-and-co-upper-04.png', 3),
('Arte 2', 'Assets/img/happines-and-co-upper-02.png', 3),
('Arte 3', 'Assets/img/happines-and-co-propuesta-02.png', 3);

/* INSERTAR FAVORITOS (2 pasados y 1 futuro por usuario) */
INSERT INTO Favoritos VALUES (1, 1), (1, 2), (1, 4), 
                             (2, 2), (2, 3), (2, 5), 
                             (3, 1), (3, 3), (3, 6);
                             
/* VISTA 1: Galerías anteriores a hoy (28-02-2026) */
CREATE VIEW v_galerias_pasadas AS
SELECT g.* FROM Galerias g
JOIN Eventos e ON g.id_evento = e.id
WHERE e.fecha < '2026-02-28';

/* VISTA 2: Favoritos del Usuario 1 */
CREATE VIEW v_favoritos_ana AS
SELECT e.* FROM Eventos e
JOIN Favoritos f ON e.id = f.id_evento
WHERE f.id_usuario = 1;

/* VISTA 3: Imágenes de la galería del 12-01-2026 */
/* Nota: Como en tus datos el evento más cercano es el 12-01, usamos el ID 2 */
CREATE VIEW v_fotos_evento_enero AS
SELECT i.* FROM Imagenes_Galerias i
JOIN Galerias g ON i.id_galeria = g.id
WHERE g.id_evento = 2;

/* VISTA 4: Favoritos futuros del Usuario 2 */
CREATE VIEW v_proximos_luis AS
SELECT e.* FROM Eventos e
JOIN Favoritos f ON e.id = f.id_evento
WHERE f.id_usuario = 2 AND e.fecha > '2026-02-28';


-- Ver todas las galerías de eventos pasados
SELECT * FROM v_galerias_pasadas;

-- Ver los eventos favoritos de Ana (Usuario 1)
SELECT * FROM v_favoritos_ana;

-- Ver las fotos del evento de enero (Taller Gastronómico)
SELECT * FROM v_fotos_evento_enero;

-- Ver los próximos eventos que le interesan a Luis
SELECT * FROM v_proximos_luis;