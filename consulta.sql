-- =============================================
-- Proyecto: Análisis SQL - Base de datos empresa
-- Autor: tu nombre
-- Fecha: marzo 2026
-- Herramienta: MySQL desde terminal Linux
-- =============================================

-- PARTE 1: Creación de la base de datos
CREATE DATABASE empresa_1;
USE empresa_1;

-- Tabla departamentos
CREATE TABLE departamentos (
    id_departamento INT NOT NULL PRIMARY KEY,
    nombre_departamento VARCHAR(50)
);

-- Tabla empleados
CREATE TABLE empleados (
    id_empleado INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_1 VARCHAR(20) NOT NULL,
    nombre_2 VARCHAR(20),
    apellido_1 VARCHAR(20) NOT NULL,
    apellido_2 VARCHAR(20),
    fecha_nac DATE NOT NULL,
    ciudad VARCHAR(20),
    salario DECIMAL(10,2) NOT NULL,
    telefono_celular VARCHAR(50) NOT NULL,
    titulo_academico VARCHAR(50),
    correo_electronico VARCHAR(100) NOT NULL,
    id_departamentos INT,
    FOREIGN KEY (id_departamentos) REFERENCES departamentos(id_departamento)
);

-- PARTE 2: Inserción de datos
INSERT INTO departamentos VALUES
(1, 'Sistemas'),
(2, 'Recursos Humanos'),
(3, 'Finanzas'),
(4, 'Ventas'),
(5, 'Marketing');

INSERT INTO empleados VALUES
(1,'Jaime','Orlando','Pardo','Rubio','1998-09-18','Bucaramanga',3000000,'3057631199','Bachiller Tecnico','jaimevedra@gmail.com',1),
(2,'Maria','Adriana','Muñoz','Sicard','1991-09-11','Bogota',6000000,'312344523','Maestria','adriarte@gmail.com',2),
(3,'Karen','Andrea','Saavedra','Rubio','2001-04-08','Bucaramanga',2500000,'312324522',NULL,'karen@gmail.com',5),
(4,'Sandra','Yisel','Saavedra','Gimenez','2011-09-11','Aguachica',2000000,'213122432','Bachiller','vayisel@gmail.com',5),
(6,'fabian','Andres','Sandobal','lopez','1994-09-12','Medellin',5000000,'062547383','Tecnologo','fabian@gmail.com',1),
(7,'Carlos','Andres','Gomez','Lopez','1995-03-14','Bogota',3200000,'3102345678','Tecnologo','carlos.gomez@gmail.com',4),
(8,'Maria','Fernanda','Rodriguez','Castro','1992-07-22','Medellin',4100000,'3115678901','Profesional','maria.rodriguez@gmail.com',3),
(9,'Jorge','Luis','Ramirez','Torres','1989-11-05','Cali',3800000,'3127894561','Tecnico','jorge.ramirez@gmail.com',4),
(10,'Laura','Daniela','Martinez','Rojas','1998-01-30','Cartagena',2900000,'3134567890','Profesional','laura.martinez@gmail.com',5),
(11,'Andres','Felipe','Morales','Vega','1994-05-18','Barranquilla',4500000,'3147891234','Especializacion','andres.morales@gmail.com',4),
(12,'Paula','Andrea','Hernandez','Diaz','1997-09-09','Bogota',3100000,'3156789123','Tecnologo','paula.hernandez@gmail.com',2),
(13,'Sebastian','David','Ortega','Pardo','1993-12-12','Bucaramanga',3600000,'3163456789','Profesional','sebastian.ortega@gmail.com',1),
(14,'Natalia','Alejandra','Suarez','Mendoza','1996-06-27','Pereira',3400000,'3172348901','Tecnico','natalia.suarez@gmail.com',5),
(15,'Felipe','Santiago','Castillo','Navas','1991-04-16','Manizales',3900000,'3189012345','Maestria','felipe.castillo@gmail.com',3),
(16,'Camila','Isabel','Gutierrez','Salazar','1999-08-03','Santa Marta',2800000,'3194561230','Profesional','camila.gutierrez@gmail.com',5);

-- =============================================
-- PARTE 3: Consultas de análisis
-- =============================================

-- Consulta 1: Empleados que ganan más de 3 millones
SELECT nombre_1, apellido_1, salario 
FROM empleados 
WHERE salario > 3000000 
ORDER BY salario DESC;

-- Consulta 2: Empleados con departamento que ganan más de 3 millones
SELECT e.nombre_1, e.apellido_1, e.salario, d.nombre_departamento 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamentos = d.id_departamento 
WHERE e.salario > 3000000 
ORDER BY e.salario DESC;

-- Consulta 3: Total de empleados y salario promedio por departamento
SELECT d.nombre_departamento, COUNT(e.id_empleado) AS total_empleados, 
ROUND(AVG(e.salario)) AS salario_promedio 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamentos = d.id_departamento 
GROUP BY d.nombre_departamento 
ORDER BY salario_promedio DESC;

-- Consulta 4: Departamentos con salario promedio mayor a 3.5 millones
SELECT d.nombre_departamento, COUNT(e.id_empleado) AS total_empleados, 
ROUND(AVG(e.salario)) AS salario_promedio 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamentos = d.id_departamento 
GROUP BY d.nombre_departamento 
HAVING salario_promedio > 3500000 
ORDER BY salario_promedio DESC;

-- Consulta 5: Empleados que ganan más que el promedio general de la empresa
SELECT e.nombre_1, e.apellido_1, e.salario, d.nombre_departamento 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamentos = d.id_departamento 
WHERE e.salario > (SELECT AVG(salario) FROM empleados) 
ORDER BY e.salario DESC;

-- Consulta 6: Empleado mejor pagado por departamento
SELECT d.nombre_departamento, e.nombre_1, e.salario 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamentos = d.id_departamento 
JOIN (
    SELECT id_departamentos, MAX(salario) AS max_salario 
    FROM empleados 
    GROUP BY id_departamentos
) m ON e.id_departamentos = m.id_departamentos AND e.salario = m.max_salario 
ORDER BY e.salario DESC;

-- Consulta 7: Nombre completo, ciudad y edad de cada empleado
SELECT CONCAT(apellido_1, ', ', nombre_1) AS nombre_completo, ciudad, 
TIMESTAMPDIFF(YEAR, fecha_nac, CURDATE()) AS edad 
FROM empleados 
ORDER BY edad DESC;

-- Consulta 8: Clasificación de ciudades por salario promedio
SELECT ciudad, COUNT(*) AS total_empleados, 
ROUND(AVG(salario)) AS salario_promedio,
CASE WHEN AVG(salario) > 3500000 THEN 'Alto' ELSE 'Medio' END AS nivel
FROM empleados 
GROUP BY ciudad 
ORDER BY salario_promedio DESC;

-- Consulta 9: Empleados candidatos a revisión salarial
SELECT e.nombre_1, e.apellido_1, d.nombre_departamento, e.salario, 
ROUND(s.salario_p_total) AS salario_promedio 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamentos = d.id_departamento 
JOIN (
    SELECT id_departamentos, AVG(salario) AS salario_p_total 
    FROM empleados 
    GROUP BY id_departamentos
) s ON e.id_departamentos = s.id_departamentos 
WHERE e.salario < s.salario_p_total 
ORDER BY e.salario DESC;

-- Consulta 10: Ranking de empleados por salario dentro de su departamento
SELECT e.nombre_1, e.apellido_1, e.salario, d.nombre_departamento,
RANK() OVER (PARTITION BY e.id_departamentos ORDER BY e.salario DESC) AS posicion 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamentos = d.id_departamento;

-- Consulta 11: Total de empleados por departamento con LEFT JOIN
SELECT d.nombre_departamento, COUNT(e.id_empleado) AS cantidad_empleados 
FROM departamentos d 
LEFT JOIN empleados e ON d.id_departamento = e.id_departamentos 
GROUP BY d.nombre_departamento 
ORDER BY cantidad_empleados DESC;
