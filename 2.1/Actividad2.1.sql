use BluePrint
GO
/*
1
Listado de todos los clientes.
*/
SELECT * FROM Clientes
/*
2
Listado de todos los proyectos.
*/
SELECT * FROM Proyectos
/*
3
Listado con nombre, descripci?n, costo, fecha de inicio y de fin de todos los proyectos.
*/
SELECT Nombre, Descripcion, CostoEstimado, FechaInicio, FechaFin FROM Proyectos
/*
4
Listado con nombre, descripci?n, costo y fecha de inicio de todos los proyectos con costo mayor a cien mil pesos.
*/
SELECT Nombre, Descripcion, CostoEstimado, FechaInicio FROM Proyectos WHERE CostoEstimado > 100000
/*
5
Listado con nombre, descripci?n, costo y fecha de inicio de todos los proyectos con costo menor a cincuenta mil pesos .
*/
SELECT Nombre, Descripcion, CostoEstimado, FechaInicio FROM Proyectos WHERE CostoEstimado < 50000
/*
6
Listado con todos los datos de todos los proyectos que comiencen en el a?o 2020.
*/
SELECT * FROM Proyectos WHERE YEAR(FechaInicio) = 2020
/*
7
Listado con nombre, descripci?n y costo de los proyectos que comiencen en el a?o 2020 y cuesten m?s de cien mil pesos.
*/
SELECT Nombre, Descripcion, CostoEstimado FROM Proyectos WHERE YEAR(FechaInicio) = 2020 AND CostoEstimado > 100000
/*
8
Listado con nombre del proyecto, costo y a?o de inicio del proyecto.
*/
SELECT Nombre, CostoEstimado, YEAR(FechaInicio) FROM Proyectos
/*
9
Listado con nombre del proyecto, costo, fecha de inicio, fecha de fin y d?as de duraci?n de los proyectos.
*/
SELECT Nombre, CostoEstimado, FechaInicio, FechaFin, DATEDIFF(DAY, FechaInicio, FechaFin) FROM Proyectos
/*
10
Listado con raz?n social, cuit y tel?fono de todos los clientes cuyo IDTipo sea 1, 3, 5 o 6
*/
SELECT RazonSocial, cuit, TelefonoFijo FROM Clientes WHERE IDTipoCliente IN (1, 3, 5, 6)
/*
11
Listado con nombre del proyecto, costo, fecha de inicio y fin de todos los proyectos que no pertenezcan a los clientes 1, 5 ni 10.
*/
SELECT Nombre, CostoEstimado, FechaInicio, FechaFin FROM Proyectos WHERE IDCliente NOT IN (1, 5, 10)
/*
12
Listado con nombre del proyecto, costo y descripci?n de aquellos proyectos que hayan comenzado entre el 1/1/2018 y el 24/6/2018.
*/
SELECT Nombre, CostoEstimado, Descripcion FROM Proyectos WHERE FechaInicio = '01/01/2018' AND FechaFin = '24/06/2018'
/*
13
Listado con nombre del proyecto, costo y descripci?n de aquellos proyectos que hayan finalizado entre el 1/1/2019 y el 12/12/2019.
*/
SELECT Nombre, CostoEstimado, Descripcion FROM Proyectos WHERE FechaFin BETWEEN '01/01/2019' AND '12/12/2019'
/*
14
Listado con nombre de proyecto y descripci?n de aquellos proyectos que a?n no hayan finalizado.
*/
SELECT Nombre, Descripcion FROM Proyectos WHERE FechaFin IS NULL
/*
15
Listado con nombre de proyecto y descripci?n de aquellos proyectos que a?n no hayan comenzado.
*/
SELECT Nombre, Descripcion FROM Proyectos WHERE FechaInicio > getdate() OR FechaInicio IS NULL
/*
16
Listado de clientes cuya raz?n social comience con letra vocal.
*/
SELECT * FROM Clientes WHERE RazonSocial LIKE '[AEIOU]%' 
/*
17
Listado de clientes cuya raz?n social finalice con vocal.
*/
SELECT * FROM Clientes WHERE RazonSocial LIKE '%[AEIOU]'
/*
18
Listado de clientes cuya raz?n social finalice con la palabra 'Inc'
*/
SELECT * FROM Clientes WHERE RazonSocial LIKE '%Inc'
/*
19
Listado de clientes cuya raz?n social no finalice con vocal.
*/
SELECT * FROM Clientes WHERE RazonSocial NOT LIKE '%[AEIOU]'
/*
20
Listado de clientes cuya raz?n social no contenga espacios.
*/
SELECT * FROM Clientes WHERE RazonSocial NOT LIKE ('% %')
/*
21
Listado de clientes cuya raz?n social contenga m?s de un espacio.
*/
SELECT * FROM Clientes WHERE RazonSocial LIKE ('% % %')
/*
22
Listado de raz?n social, cuit, email y celular de aquellos clientes que tengan mail pero no tel?fono.
*/
SELECT RazonSocial, cuit, Mail, Celular FROM Clientes WHERE Mail IS NOT NULL AND TelefonoFijo IS NULL
/*
23
Listado de raz?n social, cuit, email y celular de aquellos clientes que no tengan mail pero s? tel?fono.
*/
SELECT RazonSocial, cuit, Mail, Celular FROM Clientes WHERE Mail IS NULL AND TelefonoFijo IS NOT NULL
/*
24
Listado de raz?n social, cuit, email, tel?fono o celular de aquellos clientes que tengan mail o tel?fono o celular .
*/
SELECT RazonSocial, cuit, Mail, TelefonoFijo, Celular FROM Clientes WHERE Mail IS NOT NULL OR TelefonoFijo IS NOT NULL OR Celular IS NOT NULL
/*
25
Listado de raz?n social, cuit y mail. Si no dispone de mail debe aparecer el texto "Sin mail".
*/
SELECT RazonSocial, cuit,
		CASE 
		WHEN Mail IS NULL THEN 'Sin mail'
		WHEN Mail IS NOT NULL THEN Mail
		END AS Mail
FROM Clientes
GO
/*
26
Listado de raz?n social, cuit y una columna llamada Contacto con el mail, si no posee mail, con el n?mero de celular y si no posee n?mero de celular con un texto que diga "Incontactable".
*/
SELECT RazonSocial, cuit,
		CASE
		WHEN Mail IS NOT NULL THEN Mail
		WHEN Celular IS NOT NULL THEN Celular
		WHEN TelefonoFijo IS NOT NULL THEN TelefonoFijo
		ELSE 'Incontactable'
		END AS Contacto
FROM Clientes
GO
/*
27
Listado de raz?n social, cuit y una columna llamada Contacto con el mail, si no posee mail, con el n?mero de celular y si no posee n?mero de celular con un texto que diga "Incontactable".
*/
SELECT RazonSocial, cuit,
		CASE
		WHEN Mail IS NOT NULL THEN Mail
		WHEN Mail IS NULL AND Celular IS NOT NULL THEN Celular
		ELSE 'Incontactable'
		END AS Contacto
FROM Clientes
GO