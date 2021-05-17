use BluePrint
GO
/*
1
Listar los nombres de proyecto y costo estimado de aquellos proyectos cuyo costo estimado sea mayor al promedio de costos.
*/
select P.Nombre as 'Proyecto', P.CostoEstimado as 'Costo estimado'
from Proyectos as P
where P.CostoEstimado > (select avg(P.CostoEstimado) from Proyectos as P)
Group by P.Nombre, P.CostoEstimado
order by [Costo estimado]
GO

select avg(P.CostoEstimado) as 'Promedio de costos estimados' from Proyectos as P
GO
/*
2
Listar razón social, cuit y contacto (email, celular o teléfono) de aquellos 
clientes que no tengan proyectos que comiencen en el año 2020.
*/
select CL.RazonSocial as RazonSocial, CL.CUIT as CUIT, isnull(CL.Email, isnull(CL.Celular, CL.Telefono))
from Clientes as CL
inner join Proyectos as P on CL.ID = P.IDCliente
WHERE year(P.FechaInicio) <> 2020
GO
/*
3
Listado de países que no tengan clientes relacionados.
*/
select * from Paises WHERE ID not in (
select distinct P.ID from Paises as P
inner join Ciudades as C on P.ID = C.IDPais
inner join Clientes as CL on C.ID = CL.IDCiudad)
GO
/*
4
Listado de proyectos que no tengan tareas registradas. 
*/
select * from Proyectos WHERE ID not in (
select distinct P.ID from Proyectos as P
inner join Modulos as M on P.ID = M.IDProyecto
inner join Tareas as T on M.ID = T.IDModulo)
GO
/*
5
Listado de tipos de tareas que no registren tareas pendientes.
*/
select distinct * from TiposTarea WHERE ID in (
select TT.ID from TiposTarea as TT
inner join Tareas as T on TT.ID = T.IDTipo
inner join Colaboraciones as C2 on T.ID = C2.IDTarea
WHERE T.FechaFin is not null and T.FechaFin < getdate())
GO
/*
6
Listado con ID, nombre y costo estimado de proyectos cuyo costo estimado sea 
menor al costo estimado de cualquier proyecto de clientes nacionales 
(clientes que sean de Argentina o no tengan asociado un país).
*/
select P.ID, P.Nombre, P.CostoEstimado from Proyectos as P
where P.CostoEstimado <
(SELECT min(P.CostoEstimado) from Proyectos as P
left join Clientes as CL on P.IDCliente = CL.ID
left join Ciudades as C on CL.IDCiudad = C.ID
left join Paises as PA on C.IDPais = PA.ID
WHERE CL.IDCiudad is null OR PA.Nombre = 'Argentina')
GO
/*
7
Listado de apellido y nombres de colaboradores que hayan demorado más en una 
tarea que el colaborador de la ciudad de 'Buenos Aires' que más haya demorado.
*/
select C1.Apellido + ', ' + C1.Nombre as Colaborador
from Colaboradores as C1
inner join Colaboraciones as C2 on C1.ID = C2.IDColaborador
WHERE C2.Tiempo > (select max(C2.Tiempo) from Colaboraciones as C2
inner join Colaboradores as C1 on C2.IDColaborador = C1.ID
inner join Ciudades as CI on C1.IDCiudad = CI.ID
WHERE CI.Nombre = 'Buenos Aires')
GO
/*
8
Listado de clientes indicando razón social, nombre del país (si tiene) y 
cantidad de proyectos comenzados y cantidad de proyectos por comenzar.
*/
select CL.RazonSocial, isnull(PA.Nombre, 'No posee') as País, 
(select count(P.Nombre) from Proyectos as P
WHERE P.IDCliente = CL.ID and P.FechaInicio < getdate()) as 'Proyectos comenzados',
(select count(P.Nombre) as 'Proyectos comenzados' from Proyectos as P
WHERE P.IDCliente = CL.ID and P.FechaInicio >= getdate()) as 'Proyectos por comenzar'
from Clientes as CL
left join Ciudades as CI on CL.IDCiudad = CI.ID
left join Paises as PA on CI.IDPais = PA.ID
GO
/*
9
Listado de tareas indicando nombre del módulo, nombre del tipo de tarea, 
cantidad de colaboradores externos que la realizaron y cantidad de colaboradores internos que la realizaron.
*/
select distinct T.ID as 'ID Tarea', M.Nombre as Modulo, TT.Nombre as 'Tipo de tarea', 
(select count(C1.ID) from Colaboradores as C1
WHERE C1.ID = C2.IDColaborador and C1.Tipo = 'E') as 'Colaboradores externos',
(select count(C1.ID) from Colaboradores as C1
WHERE C1.ID = C2.IDColaborador and C1.Tipo = 'I') as 'Colaboradores internos'
from TiposTarea as TT
inner join Tareas as T on TT.ID = T.IDTipo
inner join Modulos as M on T.IDModulo = M.ID
inner join Colaboraciones as C2 on T.ID = C2.IDTarea
inner join Colaboradores as C1 on C2.IDColaborador = C1.ID
Group by T.ID, M.Nombre, TT.Nombre, C2.IDColaborador
order by T.ID
GO
/*
10
Listado de proyectos indicando nombre del proyecto, costo estimado, cantidad de 
módulos cuya estimación de fin haya sido exacta, cantidad de módulos con estimación 
adelantada y cantidad de módulos con estimación demorada.
Adelantada →  estimación de fin haya sido inferior a la real.
Demorada   →  estimación de fin haya sido superior a la real.
*/
select P.Nombre as Proyecto, P.CostoEstimado as costoproyecto, 
(select count(M.ID) from Modulos as M WHERE M.FechaEstimadaFin = M.FechaFin AND P.ID = M.IDProyecto) as Exactos,
(select count(M.ID) from Modulos as M WHERE M.FechaEstimadaFin < M.FechaFin AND P.ID = M.IDProyecto)as Adelantados,
(select count(M.ID) from Modulos as M WHERE M.FechaEstimadaFin > M.FechaFin AND P.ID = M.IDProyecto)as Demorados
from Proyectos as P
inner join Modulos as MO on P.ID = MO.IDProyecto
GO
/*
11
Listado con nombre del tipo de tarea y total abonado en concepto de honorarios 
para colaboradores internos y total abonado en concepto de honorarios para colaboradores externos.
*/
select distinct TT.Nombre as TipoTarea, 
(select sum(C2.Tiempo*C2.PrecioHora) from Colaboradores as C1
inner join Colaboraciones as C2 on C1.ID = C2.IDColaborador
inner join Tareas as T on C2.IDTarea = T.ID
WHERE TT.ID = T.IDTipo AND C1.Tipo = 'I') 
as HonInternos,
(select sum(C2.Tiempo*C2.PrecioHora) from Colaboradores as C1 
inner join Colaboraciones as C2 on C1.ID = C2.IDColaborador
inner join Tareas as T on C2.IDTarea = T.ID
WHERE TT.ID = T.IDTipo AND C1.Tipo = 'E') 
as HonExternos
from TiposTarea as TT
GO
/*
12
Listado con nombre del proyecto, razón social del cliente y saldo final del proyecto. 
El saldo final surge de la siguiente fórmula: 
Costo estimado - Σ(HCE) - Σ(HCI) * 0.1
Siendo HCE → Honorarios de colaboradores externos y HCI → Honorarios de colaboradores internos.
*/
select P.Nombre as Proyecto, CL.RazonSocial,
(P.CostoEstimado - 
    (    --IMPORTANTE: CUANDO OPERE ARITMETICAMENTE, AGREGAR FUNCION IS NULL
        select isnull(sum(CO.PrecioHora * CO.Tiempo),0) from Colaboradores as C
        inner join Colaboraciones as CO on CO.IDColaborador = C.ID
        inner join Tareas as T on T.ID = CO.IDTarea
        inner join Modulos as M on M.ID = T.IDModulo
        where M.IDProyecto = P.ID and C.Tipo = 'E'
    ) - 
    (
        select isnull(sum(CO.PrecioHora * CO.Tiempo),0) from Colaboradores as C
        inner join Colaboraciones as CO on CO.IDColaborador = C.ID
        inner join Tareas as T on T.ID = CO.IDTarea
        inner join Modulos as M on M.ID = T.IDModulo
        where M.IDProyecto = P.ID and C.Tipo = 'I'
    ) * 0.1)as 'Saldo Final'
from Proyectos as P
    inner join Clientes as CL on CL.ID = P.IDCliente
GO
/*
13
Para cada módulo listar el nombre del proyecto, el nombre del módulo, el total en 
tiempo que demoraron las tareas de ese módulo y qué porcentaje de tiempo representaron 
las tareas de ese módulo en relación al tiempo total de tareas del proyecto.
*/
select M.Nombre as Modulo, P.Nombre as Proyecto, 
(select isnull(sum(C2.Tiempo),0)
from Colaboraciones as C2
inner join Tareas as T on C2.IDTarea = T.ID
inner join Modulos as M2 on T.IDModulo = M2.ID
WHERE T.IDModulo = M.ID AND M2.IDProyecto = P.ID
) as TotalTiempoModulos,
(
	(
		(select isnull(sum(C2.Tiempo),0)
		from Colaboraciones as C2
		inner join Tareas as T on C2.IDTarea = T.ID
		inner join Modulos as M2 on T.IDModulo = M2.ID
		WHERE T.IDModulo = M.ID AND M2.IDProyecto = P.ID
		) *1.0 /

		(select isnull(sum(C2.Tiempo),1)
		from Colaboraciones as C2
		inner join Tareas as T on C2.IDTarea = T.ID
		inner join Modulos as M2 on T.IDModulo = M2.ID
		inner join Proyectos as P2 on M2.IDProyecto = P2.ID
		WHERE M2.IDProyecto = P.ID
		) *1.0 
	) *100
)		
as '% de tiempo total de proyectos'
from Proyectos as P
inner join Modulos as M on P.ID = M.IDProyecto
GO
/*
14
Por cada colaborador indicar el apellido, el nombre, 'Interno' o 'Externo' según su tipo 
y la cantidad de tareas de tipo 'Testing' que haya realizado y la cantidad de tareas de tipo 
'Programación' que haya realizado.
NOTA: Se consideran tareas de tipo 'Testing' a las tareas que contengan la palabra 'Testing' en su nombre. Ídem para Programación.
*/

/*
15
Listado apellido y nombres de los colaboradores que no hayan realizado tareas de 'Diseño de base de datos'.
*/

/*
16
Por cada país listar el nombre, la cantidad de clientes y la cantidad de colaboradores.
*/

/*
17
Listar por cada país el nombre, la cantidad de clientes y la cantidad de colaboradores de 
aquellos países que no tengan clientes pero sí colaboradores.
*/

/*
18
Listar apellidos y nombres de los colaboradores internos que hayan realizado más tareas de tipo 
'Testing' que tareas de tipo 'Programación'.
*/

/*
19
Listar los nombres de los tipos de tareas que hayan abonado más del cuádruple en colaboradores internos que externos
*/

/*
20
Listar los proyectos que hayan registrado igual cantidad de estimaciones demoradas que adelantadas 
y que al menos hayan registrado alguna estimación adelantada y que no hayan registrado ninguna estimación exacta.
*/
