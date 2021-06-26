USE BluePrint
GO
/*
1) Hacer un reporte que liste por cada tipo de 
tarea el nombre, el precio de hora base 
y el promedio de valor hora real (obtenido de las colaboraciones).
*/
create view VW_Reporte_TiposTarea as
select TT.Nombre 'Tipo de tarea', TT.PrecioHoraBase '$ Hora Base',
(
	select avg(C.PrecioHora) from Colaboraciones C
	inner join Tareas T on C.IDTarea = T.ID
	where T.IDTipo = TT.ID
) 'Promedio valor hora real'
from TiposTarea TT
GO


select * from VW_Reporte_TiposTarea
/*
2) Modificar el reporte de (1) para que también 
liste una columna llamada Variación con las siguientes reglas:
Poca → Si la diferencia entre el promedio y el precio de hora base es menor a $500.
Mediana → Si la diferencia entre el promedio y el precio de hora base está entre $501 y $999.
Alta → Si la diferencia entre el promedio y el precio de hora base es $1000 o más.
*/
alter view VW_Reporte_TiposTarea as
select aux.*, 
case
	when aux.[Promedio valor hora real]-aux.[$ Hora Base] < 500
	then 'Poca'
	when aux.[Promedio valor hora real]-aux.[$ Hora Base] >= 500 and aux.[Promedio valor hora real]-aux.[$ Hora Base] <= 999
	then 'Mediana'
	when aux.[Promedio valor hora real]-aux.[$ Hora Base] >= 1000
	then 'Alta'
end as 'Variación'
from (
		select TT.Nombre 'Tipo de tarea', TT.PrecioHoraBase '$ Hora Base',
		(
			select avg(C.PrecioHora) from Colaboraciones C	
			inner join Tareas T on C.IDTarea = T.ID	
			where T.IDTipo = TT.ID
	
		) 'Promedio valor hora real'
		from TiposTarea TT
) aux
GO
/*
3) Crear un procedimiento almacenado que liste 
las colaboraciones de un colaborador cuyo ID 
se envía como parámetro.
*/
create procedure SP_Colaborations_by_Colaborator(
	@IDColaborador int
)
as
begin
	select * from Colaboraciones C2
	where C2.IDColaborador = @IDColaborador
	order by C2.IDTarea asc
end

exec SP_Colaborations_by_Colaborator 3
/*
4) Hacer una vista que liste por cada colaborador 
el apellido y nombre, el nombre del tipo (Interno o Externo) 
y la cantidad de proyectos distintos en los que haya trabajado.
Opcional: Hacer una aplicación en C# (consola, escritorio o web) 
que consuma la vista y la muestre por pantalla.
*/
create view VW_Cantidad_Proyectos_Por_Colaborador as
select C1.Apellido + ', ' + C1.Nombre Colaborador, 
case C1.Tipo
when 'I'
then 'Interno'
when 'E'
then 'Externo'
end as 'Tipo de colaborador',
(
	select distinct count(P.ID) from Proyectos P
	inner join Modulos M on P.ID = M.IDProyecto
	inner join Tareas T on M.ID = T.IDModulo
	inner join Colaboraciones C_2 on T.ID = C_2.IDTarea
	inner join Colaboradores C_1 on C_2.IDColaborador = C_1.ID
	where C1.ID = C_1.ID
) 'Cant. Proyectos'
from Colaboradores C1

select * from VW_Cantidad_Proyectos_Por_Colaborador
/*
5) Hacer un procedimiento almacenado que reciba dos 
fechas como parámetro y liste todos los datos de los 
proyectos que se encuentren entre esas fechas.
*/
create procedure SP_Proyects_between_Dates(
	@FechaInicio date,
	@FechaFin date
)
as
begin
	select * from Proyectos P
	where P.FechaInicio >= @FechaInicio
	and	P.FechaFin <= @FechaFin
	and P.FechaInicio is not null
	and P.FechaFin is not null
	order by P.FechaInicio desc
end

exec SP_Proyects_between_Dates '2000-03-15', '2020-12-20'
/*
6) Hacer un procedimiento almacenado que reciba un 
ID de Cliente, un ID de Tipo de contacto y un valor 
y modifique los datos de contacto de dicho cliente. 
El ID de Tipo de contacto puede ser: 
1 - Email, 2 - Tfono y 3 - Celular.
*/
create procedure SP_Modificar_Cliente(
	@IDCliente smallint,
	@IDTipoContacto smallint,
	@Valor varchar(100)
)
as 
begin
	select * from Clientes where ID = @IDCliente
	if @IDTipoContacto = 1
	begin
		update Clientes set EMail = @Valor where ID = @IDCliente
	end
	if @IDTipoContacto = 2
	begin
		update Clientes set Telefono = @Valor where ID = @IDCliente
	end
	else
	begin
		update Clientes set Celular = @Valor where ID = @IDCliente
	end
	print('Todo ejecutado correctamente')
	select * from Clientes where ID = @IDCliente
end

exec SP_Modificar_Cliente 1,2,12345678
/*
7) Hacer un procedimiento almacenado que reciba un 
ID de Módulo y realice la baja lógica tanto del módulo 
como de todas sus tareas futuras. Utilizar una transacción 
para realizar el proceso de manera atómica.
*/
create procedure SP_BAJA_MODULO(
	@IDModulo int
)
as
begin
	select * from Modulos where ID = @IDModulo
	select * from Tareas where IDModulo = @IDModulo
	begin try
		begin transaction
			update Modulos set Estado = 0 where ID = @IDModulo
			update Tareas set Estado = 0 where IDModulo = @IDModulo --and FechaInicio >= getdate()

		commit transaction
	end try
	begin catch
		rollback transaction
		raiserror('No se pudo realizar la baja del modulo, ni las tareas asociadas a el.',16,1)
	end catch
	select * from Modulos where ID = @IDModulo
	select * from Tareas where IDModulo = @IDModulo
end

exec SP_BAJA_MODULO 1

--update Modulos set Estado = 1 where ID = 1
--update Tareas set Estado = 1 where IDModulo = 1