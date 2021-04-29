use BluePrint
GO
/*
1
Por cada cliente listar razón social, cuit y nombre del tipo de cliente.
*/
SELECT CL.RazonSocial, CL.cuit, TC.Nombre 
from Clientes as CL
inner join TiposCliente as TC on CL.IDTipo = TC.ID
GO
/*
2
Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. 
Sólo de aquellos clientes que posean ciudad y país.
*/
SELECT CL.RazonSocial, CL.cuit, C.Nombre, P.Nombre
from Clientes as CL
inner join Ciudades as C on CL.IDCiudad = C.ID
inner join Paises as P on C.IDPais = P.ID
GO
/*
3
Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. 
Listar también los datos de aquellos clientes que no tengan ciudad relacionada.
*/
SELECT CL.RazonSocial, CL.cuit, C.Nombre, P.Nombre
from Clientes as CL
left join Ciudades as C on C.ID = CL.IDCiudad
left join Paises as P on P.ID = C.IDPais
GO
/*
4
Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. 
Listar también los datos de aquellas ciudades y países que no tengan clientes relacionados.
*/
SELECT CL.RazonSocial, CL.cuit, C.Nombre as Ciudad, P.Nombre as Pais
from Clientes as CL
right join Ciudades as C on C.ID = CL.IDCiudad
right join Paises as P on P.ID = C.IDPais
GO
/*
5
Listar los nombres de las ciudades que no tengan clientes asociados. 
Listar también el nombre del país al que pertenece la ciudad.
*/
SELECT C.Nombre as Ciudad, P.Nombre as Pais
from Clientes as CL
right join Ciudades as C on C.ID = CL.IDCiudad
right join Paises as P on P.ID = C.IDPais
WHERE CL.ID IS NULL
GO
/*
6
Listar para cada proyecto el nombre del proyecto, el costo, la razón social del cliente, 
el nombre del tipo de cliente y el nombre de la ciudad (si la tiene registrada) de aquellos 
clientes cuyo tipo de cliente sea 'Extranjero' o 'Unicornio'.
*/
SELECT P.Nombre as Proyecto, P.CostoEstimado as Costo_Proyecto, 
CL.RazonSocial as Razon_Social, TP.Nombre as Tipo_de_Cliente, C.Nombre as Ciudad
from Proyectos as P
inner join Clientes as CL on P.IDCliente = CL.ID
inner join TiposCliente as TP on CL.IDTipo = TP.ID
left join Ciudades as C on C.ID = CL.IDCiudad
WHERE TP.Nombre IN ('Extranjero', 'Unicornio')
GO
/*
7
Listar los nombres de los proyectos de aquellos clientes que sean 
de los países 'Argentina' o 'Italia'.
*/
SELECT P.Nombre as Proyecto
from Proyectos as P
inner join Clientes as CL on P.IDCliente = CL.ID
inner join Ciudades as C on CL.IDCiudad = C.ID
inner join Paises as PA on C.IDPais = PA.ID
WHERE PA.Nombre IN ('Argentina', 'Italia')
GO
/*
8
Listar para cada módulo el nombre del módulo, el costo estimado del módulo, 
el nombre del proyecto, la descripción del proyecto y el costo estimado del 
proyecto de todos aquellos proyectos que hayan finalizado.
*/
SELECT M.Nombre as Modulo, M.CostoEstimado as Costo_Modulo, 
P.Nombre as Proyecto, P.Descripcion as Descripcion_Proyecto,
P.CostoEstimado as Costo_Estimado_Proyecto
from Modulos as M
inner join Proyectos as P on M.IDProyecto = P.ID
WHERE P.FechaFin <= getdate()
GO
/*
9
Listar los nombres de los módulos y el nombre del proyecto, de aquellos módulos 
cuyo tiempo estimado de realización sea de más de 100 horas.
*/
SELECT M.Nombre as Modulo, P.Nombre as Proyecto
from Modulos as M
inner join Proyectos as P on M.IDProyecto = P.ID
WHERE M.TiempoEstimado > 100
GO
/*
10
Listar nombres de módulos, nombre del proyecto, descripción y tiempo estimado 
de aquellos módulos cuya fecha estimada de fin sea mayor a la fecha real de fin 
y el costo estimado del proyecto sea mayor a cien mil.
*/
SELECT M.Nombre as Modulo, P.Nombre as Proyecto, 
P.Descripcion as Descripcion_Proyecto, M.TiempoEstimado as TiempoEstimado_Modulo
from Modulos as M
inner join Proyectos as P on M.IDProyecto = P.ID
WHERE M.FechaEstimadaFin > M.FechaFin
AND P.CostoEstimado > 100000
GO
/*
11
Listar nombre de proyectos, sin repetir, que registren módulos que hayan 
finalizado antes que el tiempo estimado.
*/
SELECT distinct P.Nombre as Proyectos
from Proyectos as P
inner join Modulos as M on P.ID = M.IDProyecto
WHERE M.FechaEstimadaFin > M.FechaFin
GO
/*
12
Listar nombre de ciudades, sin repetir, que no registren clientes pero sí colaboradores.
*/
SELECT DISTINCT C.Nombre
from Ciudades as C
left join Clientes as CL on C.ID = CL.IDCiudad
inner join Colaboradores as CO on C.ID = CO.IDCiudad
WHERE CL.IDCiudad IS NULL AND CO.IDCiudad IS NOT NULL
GO
/*
13
Listar el nombre del proyecto y nombre de módulos de aquellos módulos que 
contengan la palabra 'login' en su nombre o descripción.
*/
SELECT P.Nombre, M.Nombre
from Proyectos as P
inner join Modulos as M on M.IDProyecto = P.ID
WHERE M.Nombre LIKE ('%login%') OR M.Descripcion LIKE ('%login%')
GO
/*
14
Listar el nombre del proyecto y el nombre y apellido de todos los colaboradores 
que hayan realizado algún tipo de tarea cuyo nombre contenga 'Programación' o 'Testing'. 
Ordenarlo por nombre de proyecto de manera ascendente.
*/
--C1=Colaboradores
--C2=Colaboraciones
SELECT P.Nombre as Proyecto, C1.Nombre + ', ' + C1.Apellido as Colaborador
from Colaboradores as C1
inner join Colaboraciones as C2 on C2.IDColaborador = C1.ID
inner join Tareas as T on C2.IDTarea = T.ID
inner join Modulos as M on T.IDModulo = M.ID
inner join Proyectos as P on M.IDProyecto = P.ID
inner join TiposTarea as TT on TT.ID = T.ID
WHERE TT.Nombre LIKE ('%Programación%') OR TT.Nombre LIKE ('%Testing%')
ORDER BY P.Nombre ASC
GO
/*
15
Listar nombre y apellido del colaborador, nombre del módulo, nombre del tipo de tarea, 
precio hora de la colaboración y precio hora base de aquellos colaboradores que hayan 
cobrado su valor hora de colaboración más del 50% del valor hora base.
*/
SELECT C1.Nombre + ', ' + C1.Apellido as Colaborador, M.Nombre as Modulo, TT.Nombre as Tipo_de_Tarea,
TT.PrecioHoraBase as Precio_Hora_Base, C2.PrecioHora as Precio_Hora_Colaboración
from Colaboradores C1
inner join Colaboraciones as C2 on C1.ID = C2.IDColaborador
inner join Tareas as T on C2.IDTarea = T.ID
inner join Modulos as M on T.IDModulo = M.ID
inner join TiposTarea as TT on T.IDTipo = TT.ID
WHERE C2.PrecioHora > TT.PrecioHoraBase*1.5
GO
/*
16
Listar nombres y apellidos de las tres colaboraciones de colaboradores externos que 
más hayan demorado en realizar alguna tarea cuyo nombre de tipo de tarea contenga 'Testing'.
*/
SELECT TOP 3 C1.Nombre + ', ' + C1.Apellido as Colaborador
from Colaboradores as C1
inner join Colaboraciones as C2 on C1.ID = C2.IDColaborador
inner join Tareas as T on C2.IDTarea = T.ID
inner join TiposTarea as TT on T.IDTipo = TT.ID
WHERE TT.Nombre LIKE ('%Testing%') AND C1.Tipo LIKE ('E')
ORDER BY C2.Tiempo DESC
GO
/*
17
Listar apellido, nombre y mail de los colaboradores argentinos que sean internos y 
cuyo mail no contenga '.com'.
*/
SELECT C1.Nombre + ', ' + C1.Apellido as Colaborador, C1.EMail as Mail
from Colaboradores as C1
inner join Ciudades as CI on C1.IDCiudad = CI.ID
inner join Paises as P on CI.IDPais = P.ID
WHERE C1.EMail NOT LIKE '%.com%' AND C1.Tipo LIKE 'I' AND P.Nombre LIKE 'Argentina'
GO
/*
18
Listar nombre del proyecto, nombre del módulo y tipo de tarea de aquellas tareas 
realizadas por colaboradores externos.
*/
SELECT P.Nombre as Proyecto, M.Nombre as Modulo, TT.Nombre as Tarea_Realizada
from Proyectos as P
inner join Modulos as M on P.ID = M.IDProyecto
inner join Tareas as T on M.ID = T.IDModulo
inner join TiposTarea as TT on T.IDTipo = TT.ID
inner join Colaboraciones as C2 on T.ID = C2.IDTarea
inner join Colaboradores as C1 on C2.IDColaborador = C1.ID
WHERE C1.Tipo LIKE 'E'
GO
/*
19
Listar nombre de proyectos que no hayan registrado tareas.
*/
SELECT DISTINCT P.Nombre as Proyecto
from Proyectos as P
inner join Modulos as M on P.ID = M.IDProyecto
left join Tareas as T on M.ID = T.IDModulo
WHERE T.ID IS NULL
GO
/*
20
Listar apellidos y nombres, sin repeticiones, de aquellos colaboradores que hayan 
trabajado en algún proyecto que aún no haya finalizado.
*/
SELECT DISTINCT C1.Apellido + ', ' + C1.Nombre as Colaboradores
from Colaboradores as C1
inner join Colaboraciones as C2 on C1.ID = C2.IDColaborador
inner join Tareas as T on C2.IDTarea = T.ID
inner join Modulos as M on T.IDModulo = M.ID
inner join Proyectos as P on M.IDProyecto = P.ID
WHERE P.FechaFin IS NULL
ORDER BY Colaboradores ASC
GO