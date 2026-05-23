-- ============================================================
-- Script SQL completo para el proyecto DatosUsuario
-- Base de datos: datosusuario
-- Motor: MySQL 8+ / MariaDB (XAMPP)
-- ============================================================

CREATE DATABASE IF NOT EXISTS datosusuario;
USE datosusuario;

-- ------------------------------------------------------------
-- Tablas
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS perfiles (
  id_perfil INT PRIMARY KEY AUTO_INCREMENT,
  perfil    VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS usuarios (
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

CREATE TABLE IF NOT EXISTS actividades (
  id_actividad  INT PRIMARY KEY AUTO_INCREMENT,
  nom_actividad VARCHAR(45),
  enlace        VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS gesactividad (
  idgesActividad INT PRIMARY KEY AUTO_INCREMENT,
  id_perfil      INT,
  id_actividad   INT,
  FOREIGN KEY (id_perfil)    REFERENCES perfiles(id_perfil),
  FOREIGN KEY (id_actividad) REFERENCES actividades(id_actividad)
);

-- ------------------------------------------------------------
-- Tabla de auditoría (nueva)
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS auditoria (
  id_auditoria    INT PRIMARY KEY AUTO_INCREMENT,
  idusu           INT NOT NULL,
  usuario         VARCHAR(20) NOT NULL,
  nombre_completo VARCHAR(61),
  accion          VARCHAR(50) NOT NULL,
  modulo          VARCHAR(30) NOT NULL,
  descripcion     VARCHAR(255),
  ip_address      VARCHAR(45),
  fecha           DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (idusu) REFERENCES usuarios(idusu) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Datos de prueba iniciales
-- ------------------------------------------------------------

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
  (5, 'Prueba20',                 'prueba20.jsp'),
  (6, 'Gestión de Roles',         'gestionRoles.jsp'),
  (7, 'Nueva Actividad',          'regActividad.jsp'),
  (8, 'Auditoría',                'auditoria.jsp');

-- Administrador: accede a todo (incluyendo Auditoría)
INSERT INTO gesactividad VALUES
  (1, 1, 1), (2, 1, 2), (3, 1, 3), (4, 1, 4), (5, 1, 5),
  (7, 1, 6), (8, 1, 7), (9, 1, 8);

-- Operador: solo lista de usuarios
INSERT INTO gesactividad VALUES
  (6, 2, 1);
