/* 1. CREAR ESQUEMA Y USARLO */
DROP SCHEMA IF EXISTS happiness_co;
CREATE SCHEMA happiness_co;
USE happiness_co;

/* 2. CREACIÓN DE TABLAS */

create table Usuarios (
    id int auto_increment ,
    nombre varchar(100) not null,
    email varchar(100) not null,
    password varchar(100) not null,
    constraint pk_usuarios primary key(id),
    constraint uq_email unique (email)
);

create table Eventos (
    id int auto_increment ,
    fecha date not null,
    titulo varchar(120) not null,
    ubicacion varchar(100),
    descripcion text,
    constraint pk_eventos primary key(id)
);

create table Galerias (
    id int auto_increment ,
    titulo varchar(150),
    id_evento int,
    constraint pk_galerias primary key (id),
    constraint fk_galeria_evento foreign key (id_evento) references Eventos(id) on delete cascade
);

create table Imagenes_Galerias (
    id int auto_increment,
    titulo varchar(150),
    imagen varchar(255),
    id_galeria int,
    constraint pk_imagenes primary key (id),
    constraint fk_imagenes_galeria foreign key (id_galeria) references Galerias(id) on delete cascade
);

create table Favoritos (
    id_usuario int,
    id_evento int,
    constraint pk_favoritos primary key (id_usuario, id_evento),
    constraint fk_fav_usuario foreign key (id_usuario) references Usuarios(id) on delete cascade,
    constraint fk_fav_evento foreign key (id_evento) references Eventos(id) on delete cascade
);

/* VER LAS TABLAS */
select * from usuarios;
select * from eventos;
select * from galerias;
select * from imagenes_galerias;
select * from favoritos;

/* 3. INSERTAR DATOS */

-- Usuarios 
insert into Usuarios (nombre, email, password) values
('Asier Garcia', 'asier@garcia.es', '1234'),
('Lucas Alvarez', 'lucassalvarez@.com', '9876'),
('Lucia Sanchez', 'luciasanchez@gmail.com', '0000');

-- Eventos 
insert into Eventos (id, fecha, titulo, ubicacion, descripcion) values
(1, '2026-01-01', 'Concierto Año Nuevo', 'Oviedo', 'Tradicional gala lírica'), 
(2, '2026-01-12', 'Cirque du Soleil', 'Gijón', 'Espectáculo itinerante'), 
(3, '2026-01-24', 'Festival de Cine', 'Gijón', 'Edición especial invierno'), 
(4, '2026-06-05', 'American Buffalo', 'Gijón', 'Teatro en el Jovellanos'),
(5, '2026-06-15', 'Temporada de Ópera', 'Oviedo', 'Producción Teatro Campoamor'), 
(6, '2026-06-25', 'Gijón Sound Festival', 'Gijón', 'Música independiente');  

-- Galerías 
insert into Galerias (id, titulo, id_evento) values 
(10, 'Fotos Gala Año Nuevo', 1),
(20, 'Fotos Circo del Sol', 2),
(30, 'Fotos Alfombra Roja Gijón', 3);

-- Imágenes de las galerías 
insert into Imagenes_Galerias (titulo, imagen, id_galeria) values 
('Orquesta', 'año.jfif', 10), ('Público', 'año2.jfif', 10), ('Director', 'oviedo_gala.jpg', 10),
('Acróbatas', 'circosol.jfif', 20), ('Escenario', 'circosol2.jfif', 20), ('Carpas', 'circo_vuelo.png', 20),
('Premiados', 'festivalcine.jfif', 30), ('Gala', 'festivalcine2.jfif', 30), ('Teatro', 'cine_gijon.jpg', 30);

-- Favoritos 
insert into Favoritos values (1, 1), (1, 2), (1, 4); 
insert into Favoritos values (2, 2), (2, 3), (2, 5); 
insert into Favoritos values (3, 1), (3, 4), (3, 6);

/* 4. creacion de vistas */

-- vista 1: galerías anteriores al 28-02-2026
create view v_galerias_historial as
select g.* from galerias g
join eventos e on g.id_evento = e.id
where e.fecha < '2026-02-28';

-- vista 2: favoritos del usuario 1
create view v_favoritos_usuario_1 as
select e.titulo, e.fecha, e.ubicacion from eventos e
join favoritos f on e.id = f.id_evento
where f.id_usuario = 1;

-- vista 3: imágenes de la galería del evento del 12-01-2026 (id_evento 2)
create view v_imagenes_circo_sol as
select i.titulo, i.imagen from imagenes_galerias i
join galerias g on i.id_galeria = g.id
where g.id_evento = 2;

-- vista 4: favoritos del usuario 2 posteriores al 28-02-2026
create view v_favoritos_futuros_usuario_2 as
select e.titulo, e.fecha from eventos e
join favoritos f on e.id = f.id_evento
where f.id_usuario = 2 and e.fecha > '2026-02-28';

/* consultas */
select * from v_galerias_historial;
select * from v_favoritos_usuario_1;
select * from v_imagenes_circo_sol;
select * from v_favoritos_futuros_usuario_2;