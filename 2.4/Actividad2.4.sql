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
Listar razón social, cuit y contacto (email, celular o teléfono) de aquellos clientes que no tengan proyectos que comiencen en el año 2020.
*/

/*
3
Listado de países que no tengan clientes relacionados.
*/

/*
4
Listado de proyectos que no tengan tareas registradas. 
*/

/*
5
Listado de tipos de tareas que no registren tareas pendientes.
*/

/*
6
Listado con ID, nombre y costo estimado de proyectos cuyo costo estimado sea menor al costo estimado de cualquier proyecto de clientes nacionales (clientes que sean de Argentina o no tengan asociado un país).
*/

/*
7
Listado de apellido y nombres de colaboradores que hayan demorado más en una tarea que el colaborador de la ciudad de 'Buenos Aires' que más haya demorado.
*/

/*
8
Listado de clientes indicando razón social, nombre del país (si tiene) y cantidad de proyectos comenzados y cantidad de proyectos por comenzar.
*/

/*
9
Listado de tareas indicando nombre del módulo, nombre del tipo de tarea, cantidad de colaboradores externos que la realizaron y cantidad de colaboradores internos que la realizaron.
*/

/*
10
Listado de proyectos indicando nombre del proyecto, costo estimado, cantidad de módulos cuya estimación de fin haya sido exacta, cantidad de módulos con estimación adelantada y cantidad de módulos con estimación demorada.
Adelantada →  estimación de fin haya sido inferior a la real.
Demorada   →  estimación de fin haya sido superior a la real.
*/

/*
11
Listado con nombre del tipo de tarea y total abonado en concepto de honorarios para colaboradores internos y total abonado en concepto de honorarios para colaboradores externos.
*/

/*
12
Listado con nombre del proyecto, razón social del cliente y saldo final del proyecto. El saldo final surge de la siguiente fórmula: 
Costo estimado - Σ(HCE) - Σ(HCI) * 0.1
Siendo HCE → Honorarios de colaboradores externos y HCI → Honorarios de colaboradores internos.
*/

/*
13
Para cada módulo listar el nombre del proyecto, el nombre del módulo, el total en tiempo que demoraron las tareas de ese módulo y qué porcentaje de tiempo representaron las tareas de ese módulo en relación al tiempo total de tareas del proyecto.
*/

/*
14
Por cada colaborador indicar el apellido, el nombre, 'Interno' o 'Externo' según su tipo y la cantidad de tareas de tipo 'Testing' que haya realizado y la cantidad de tareas de tipo 'Programación' que haya realizado.
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
Listar por cada país el nombre, la cantidad de clientes y la cantidad de colaboradores de aquellos países que no tengan clientes pero sí colaboradores.
*/

/*
18
Listar apellidos y nombres de los colaboradores internos que hayan realizado más tareas de tipo 'Testing' que tareas de tipo 'Programación'.
*/

/*
19
Listar los nombres de los tipos de tareas que hayan abonado más del cuádruple en colaboradores internos que externos
*/

/*
20
Listar los proyectos que hayan registrado igual cantidad de estimaciones demoradas que adelantadas y que al menos hayan registrado alguna estimación adelantada y que no hayan registrado ninguna estimación exacta.
*/
