-- ============================================================
-- Script SQL para el proyecto DatosUsuario
-- Base de datos: datosusuario
-- Motor: MySQL 8+
-- ============================================================

CREATE DATABASE IF NOT EXISTS datosusuario;
USE datosusuario;

-- ------------------------------------------------------------
-- Tabla: perfiles
-- ------------------------------------------------------------
CREATE TABLE perfiles (
  id_perfil INT PRIMARY KEY AUTO_INCREMENT,
  perfil    VARCHAR(30)
);

-- ------------------------------------------------------------
-- Tabla: usuarios
-- ------------------------------------------------------------
CREATE TABLE usuarios (
  idusu     INT PRIMARY KEY AUTO_INCREMENT,
  num_docu  VARCHAR(20),
  nombre    VARCHAR(30),
  apellido  VARCHAR(30),
  email     VARCHAR(60),
  usuario   VARCHAR(20),
  clave     VARCHAR(8),
  id_perfil INT,
  FOREIGN KEY (id_perfil) REFERENCES perfiles(id_perfil)
);

-- ------------------------------------------------------------
-- Tabla: actividades
-- ------------------------------------------------------------
CREATE TABLE actividades (
  id_actividad  INT PRIMARY KEY AUTO_INCREMENT,
  nom_actividad VARCHAR(45),
  enlace        VARCHAR(100)
);

-- ------------------------------------------------------------
-- Tabla: gesactividad
-- ------------------------------------------------------------
CREATE TABLE gesactividad (
  idgesActividad INT PRIMARY KEY AUTO_INCREMENT,
  id_perfil      INT,
  id_actividad   INT,
  FOREIGN KEY (id_perfil)    REFERENCES perfiles(id_perfil),
  FOREIGN KEY (id_actividad) REFERENCES actividades(id_actividad)
);

-- ============================================================
-- Datos de prueba
-- ============================================================

INSERT INTO perfiles VALUES
  (1, 'Administrador'),
  (2, 'Operador');

INSERT INTO usuarios VALUES
  (1, '123456', 'Cristiano', 'Ronaldo', 'cr7@test.com',  'admin',    '1234', 1),
  (2, '654321', 'Juan',      'Perez',   'juan@test.com', 'operador', '1234', 2);

INSERT INTO actividades VALUES
  (1, 'Lista de usuarios',        'listarUsuarios.jsp'),
  (2, 'Registro Usuario',         'regUsuario.jsp'),
  (3, 'Registro de Actividades',  'regActividad.jsp'),
  (4, 'Gestión Actividades',      'gestActividades.jsp'),
  (5, 'Prueba20',                 'prueba20.jsp');

INSERT INTO gesactividad VALUES
  (1, 1, 1), (2, 1, 2), (3, 1, 3), (4, 1, 4), (5, 1, 5),
  (6, 2, 1);
