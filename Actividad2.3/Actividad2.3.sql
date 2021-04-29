use BluePrint
GO
/*
1
La cantidad de colaboradores
*/
SELECT count(*) as 'Cantidad de colaboradores' from Colaboradores as C
where C.ID is not null
GO
/*
2
La cantidad de colaboradores nacidos entre 1990 y 2000.
*/
SELECT count(*) as 'Cantidad de colaboradores' from Colaboradores as C
where C.ID is not null AND Year(C.FechaNacimiento) between 1990 and 2000
GO
/*
3
El promedio de precio hora base de los tipos de tareas
*/
SELECT avg(TT.PrecioHoraBase) as 'Promedio hora base' from TiposTarea as TT
WHERE TT.ID is not null
GO
/*
4
El promedio de costo de los proyectos iniciados en el año 2019.
*/
SELECT avg(P.CostoEstimado) as Promedio_Costo
from Proyectos as P
WHERE Year(P.FechaInicio) = 2019
GO
/*
5
El costo más alto entre los proyectos de clientes de tipo 'Unicornio'
*/
SELECT MAX(P.CostoEstimado) as Costo_Maximo
from Proyectos as P
inner join Clientes as CL on P.IDCliente = CL.ID
inner join TiposCliente as TP on CL.IDTipo = TP.ID
WHERE TP.Nombre = 'Unicornio'
GO
/*
6
El costo más bajo entre los proyectos de clientes del país 'Argentina'
*/
SELECT MIN(P.CostoEstimado) as Costo_Minimo
from Proyectos as P
inner join Clientes as CL on P.IDCliente = CL.ID
inner join Ciudades as C on CL.IDCiudad = C.ID
inner join Paises as PA on C.IDPais = PA.ID
WHERE PA.Nombre = 'Argentina'
GO
/*
7
La suma total de los costos estimados entre todos los proyectos.
*/
SELECT SUM(P.CostoEstimado) as SUMA from Proyectos as P
WHERE P.ID IS NOT NULL
GO
/*
8
Por cada ciudad, listar el nombre de la ciudad y la cantidad de clientes.
*/
SELECT C.Nombre, count(C.Nombre) as Cantidad 
from Clientes as CL
inner join Ciudades as C on CL.IDCiudad = C.ID
Group by C.Nombre
GO
/*
9
Por cada país, listar el nombre del país y la cantidad de clientes.
*/
SELECT P.Nombre as Pais, count(C.Nombre) as Cantidad from Clientes as CL
inner join Ciudades as C on CL.IDCiudad = C.ID
inner join Paises as P on C.IDPais = P.ID
Group by P.Nombre
GO
/*
10
Por cada tipo de tarea, la cantidad de colaboraciones registradas. 
Indicar el tipo de tarea y la cantidad calculada.
*/
SELECT TT.Nombre as Nombre_Tarea, count(C2.IDColaborador) as Colaboraciones_Registradas
from Colaboraciones as C2
inner join Tareas as T on C2.IDTarea = T.ID
inner join TiposTarea as TT on T.IDTipo = TT.ID
Group by TT.Nombre
GO
/*
11
Por cada tipo de tarea, la cantidad de colaboradores distintos 
que la hayan realizado. Indicar el tipo de tarea y la cantidad calculada.
*/
select TT.Nombre as 'Tipo de tarea', COUNT(distinct C1.ID) as Colaboradores
from TiposTarea as TT
inner join Tareas as T on TT.ID = T.IDTipo
inner join Colaboraciones as C2 on T.ID = C2.IDTarea
inner join Colaboradores as C1 on C2.IDColaborador = C1.ID
Group by TT.Nombre
GO
/*
12
Por cada módulo, la cantidad total de horas trabajadas. Indicar el ID, 
nombre del módulo y la cantidad totalizada. Mostrar los módulos sin 
horas registradas con 0.
*/
SELECT M.ID as ID, M.Nombre as Modulo, isnull(sum(C2.Tiempo), 0) as Horas_Trabajadas
from Modulos as M
inner join Tareas as T on M.ID = T.IDModulo
inner join Colaboraciones as C2 on T.ID = C2.IDTarea
Group by M.ID, M.Nombre
order by M.ID
GO
/*
13
Por cada módulo y tipo de tarea, el promedio de horas trabajadas. 
Indicar el ID y nombre del módulo, el nombre del tipo de tarea y el total calculado.
*/
SELECT M.ID as ID, M.Nombre as Modulo, TT.Nombre as Tipo_Tarea, 
avg(C2.Tiempo) as Promedio_Horas_Trabajadas
from Modulos as M
inner join Tareas as T on M.ID = T.IDModulo
inner join Colaboraciones as C2 on T.ID = C2.IDTarea
inner join TiposTarea as TT on T.IDTipo = TT.ID
Group By M.ID, TT.Nombre, M.Nombre
order by TT.Nombre
GO
/*
14
Por cada módulo, indicar su ID, apellido y nombre del colaborador y 
total que se le debe abonar en concepto de colaboraciones realizadas en dicho módulo.
*/
select M.ID AS ID_MODULO, M.Nombre as Modulo, C1.Nombre + ' ' + C1.Apellido as Apenom, SUM(C2.PrecioHora*C2.Tiempo) as SUMA
from Modulos as M
inner join Tareas as T on M.ID = T.IDModulo
inner join Colaboraciones as C2 on T.ID = C2.IDTarea
inner join Colaboradores as C1 on C2.IDColaborador = C1.ID
Group by M.ID, M.Nombre, C1.Apellido, C1.Nombre
GO
/*
15
Por cada proyecto indicar el nombre del proyecto y la cantidad de horas 
registradas en concepto de colaboraciones y el total que debe abonar en 
concepto de colaboraciones.
*/
select P.Nombre AS 'ID Proyecto', SUM(C2.Tiempo) as 'Horas registradas', SUM(C2.PrecioHora*C2.Tiempo) as 'Total a abonar'
from Proyectos as P
inner join Modulos as M on P.ID = M.IDProyecto
inner join Tareas as T on M.ID = T.IDModulo
inner join Colaboraciones as C2 on T.ID = C2.IDTarea
inner join Colaboradores as C1 on C2.IDColaborador = C1.ID
Group by P.Nombre
GO
/*
16
Listar los nombres de los proyectos que hayan registrado menos de cinco 
colaboradores distintos y más de 100 horas total de trabajo.
*/
SELECT DISTINCT P.Nombre as Proyecto
from Proyectos as P
inner join Modulos as M on P.ID = M.IDProyecto
inner join Tareas as T on M.ID = T.IDModulo
inner join Colaboraciones as C2 on T.ID = C2.IDTarea
inner join Colaboradores as C1 on C2.IDColaborador = C1.ID
group by P.Nombre
having sum(C2.Tiempo) > 100 AND count(C1.Nombre) < 5
GO
/*
17
Listar los nombres de los proyectos que hayan comenzado en el año 2020 
que hayan registrado más de tres módulos.
*/
SELECT P.Nombre as Proyecto
from Proyectos as P
inner join Modulos as M on P.ID = M.IDProyecto
Where year(P.FechaInicio) = 2020
Group by P.Nombre
having count(M.ID) > 3
select * from Proyectos
/*
18
Listar para cada colaborador externo, el apellido y nombres y el tiempo 
máximo de horas que ha trabajo en una colaboración. 
*/

/*
19
Listar para cada colaborador interno, el apellido y nombres y el promedio 
percibido en concepto de colaboraciones.
*/

/*
20
Listar el promedio percibido en concepto de colaboraciones para colaboradores 
internos y el promedio percibido en concepto de colaboraciones para colaboradores externos.
*/

/*
21
Listar el nombre del proyecto y el total neto estimado. Este último valor 
surge del costo estimado menos los pagos que requiera hacer en concepto de colaboraciones.
*/

/*
22
Listar la cantidad de colaboradores distintos que hayan colaborado en 
alguna tarea que correspondan a proyectos de clientes de tipo 'Unicornio'.
*/

/*
23
La cantidad de tareas realizadas por colaboradores del país 'Argentina'.
*/

/*
24
Por cada proyecto, la cantidad de módulos que se haya estimado mal la 
fecha de fin. Es decir, que se haya finalizado antes o después que la 
fecha estimada. Indicar el nombre del proyecto y la cantidad calculada.
*/