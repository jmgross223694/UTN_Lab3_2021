use BluePrint
GO
/*
1) Hacer un trigger que al ingresar una colaboración obtenga 
el precio de la misma a partir del precio hora base del tipo 
de tarea. Tener en cuenta que si el colaborador es externo 
el costo debe ser un 20% más caro.
*/
create trigger TR_PRECIO_COLABORACION on Colaboraciones
after insert
as
begin
	declare @IDTarea int
	set @IDTarea = (select IDTarea from inserted)
	declare @IDColaborador int
	set @IDColaborador = (select IDColaborador from inserted)
	declare @TipoColaborador char(1)
	set @TipoColaborador = (select C.Tipo from inserted 
							inner join Colaboradores C on 
							IDColaborador = C.ID)
	declare @CostoColaboracion money
	set @CostoColaboracion = (select Tiempo*TT.PrecioHoraBase from inserted
							inner join Tareas T on IDTarea = T.ID
							inner join TiposTarea TT on T.IDTipo = TT.ID)
	if @TipoColaborador = 'E'
	begin
		set @CostoColaboracion = @CostoColaboracion*1.2
	end
	update Colaboraciones set PrecioHora = @CostoColaboracion where IDTarea = @IDTarea and IDColaborador = @IDColaborador
end

insert into Colaboraciones(IDTarea, IDColaborador, Tiempo, PrecioHora, Estado)
			values (7, 1, 10, 0, 1) --INTERNO

insert into Colaboraciones(IDTarea, IDColaborador, Tiempo, PrecioHora, Estado)
			values (7, 8, 10, 0, 1) --EXTERNO

/*
delete from Colaboraciones where IDTarea = 7

select * from Colaboraciones where IDTarea = 50

update Colaboraciones set PrecioHora = 150
*/

/*
2) Hacer un trigger que no permita que un colaborador registre 
más de 15 tareas en un mismo mes. De lo contrario generar un 
error con un mensaje aclaratorio.
*/
--create 
create trigger TR_CONTAR_TAREAS_X_MES on Colaboraciones
instead of insert
as
begin
	declare @Tiempo int = (select Tiempo from inserted)
	declare @PrecioHora money = (select PrecioHora from inserted)
	declare @Estado bit = (select Estado from inserted)
	declare @Colaborador varchar(100)
	set @Colaborador = (select C1.Apellido + ', ' + C1.Nombre from Colaboradores C1 inner join Inserted C2 on C1.ID = IDColaborador)
	declare @IDTarea int
	set @IDTarea = (select IDTarea from inserted)
	declare @FechaTarea date
	select @FechaTarea = T.FechaInicio from Tareas T where T.ID = @IDTarea
	declare @IDColaborador int
	set @IDColaborador = (select IDColaborador from inserted)
	declare @CantidadTareas int
	set @CantidadTareas = (select count(C2.IDTarea) from Colaboraciones C2 
						inner join Tareas T on C2.IDTarea = T.ID
						where C2.IDColaborador = @IDColaborador
						and month(T.FechaInicio) = month(@FechaTarea)
						and year(T.FechaInicio) = year(@FechaTarea))
	if @CantidadTareas >= 15
	begin
		declare @Mes varchar(2) = month(@FechaTarea)
		declare @Anio varchar(4) = year(@FechaTarea)
		print('Se ha alcanzado el máximo de 15 tareas, en el mes ' + @Mes + ', del año ' + @Anio + ', para el colaborador: ' + @Colaborador + '.')
	end
	if @CantidadTareas < 15
	begin
		insert into Colaboraciones values(@IDTarea, @IDColaborador, @Tiempo, @PrecioHora, @Estado)
	end
end

/*
insert into Tareas (IDModulo, IDTipo, FechaInicio, FechaFin, Estado)
			values (23, 10, '2020-05-01', '2020-06-01', 1)

insert into Colaboraciones(IDTarea, IDColaborador, Tiempo, PrecioHora, Estado)
			values (239, 1, 10, 0, 1)

select * from Colaboraciones C inner join Tareas T on C.IDTarea = T.ID where IDColaborador = 1 and month(T.FechaInicio) = 5 and year(T.FechaInicio) = 2020
*/

/*
3) Hacer un trigger que al ingresar una tarea cuyo tipo contenga 
el nombre 'Programación' se agreguen automáticamente dos tareas 
de tipo 'Testing unitario' y 'Testing de integración'. La fecha 
de inicio y fin de las mismas debe ser NULL.
*/
create trigger TR_AGREGAR_2_TAREAS on Tareas
after insert
as
begin
	declare @NombreTarea varchar(100) = (select distinct TT.Nombre from TiposTarea TT
										inner join inserted on TT.ID = IDTipo)
	if @NombreTarea like('%Programación%')
	begin
		declare @IDModulo int = (select IDModulo from inserted)
		insert into Tareas (IDModulo, IDTipo, FechaInicio, FechaFin, Estado)
		values (@IDModulo, 10, NULL, NULL, 1)
		insert into Tareas (IDModulo, IDTipo, FechaInicio, FechaFin, Estado)
		values (@IDModulo, 11, NULL, NULL, 1)
	end
end

/*
insert into Tareas (IDModulo, IDTipo, FechaInicio, FechaFin, Estado)
		values (23, 6, '2021-06-26', '2021-07-26', 1)
*/

/*
4) Hacer un trigger que al borrar una tarea realice una baja 
lógica de la misma en lugar de una baja física.
*/
create trigger TR_BAJA_LOGICA_TAREA on Tareas
instead of delete
as
begin
	declare @IDTarea int
	select @IDTarea = ID from deleted
	update Tareas set Estado = 0 where ID = @IDTarea
end

/*
delete Tareas where ID = 257
select * from Tareas where ID = 257
*/

/*
5) Hacer un trigger que al borrar un módulo realice una baja 
lógica del mismo en lugar de una baja física. Además, debe 
borrar todas las tareas asociadas al módulo.
*/
create trigger TR_BAJA_LOGICA_MODULO_Y_TAREAS on Modulos
instead of delete
as
begin
	begin try
		begin transaction
			declare @IDModulo int
			set @IDModulo = (select ID from deleted)
			
			update Modulos set Estado = 0 where ID = @IDModulo
			
			update Tareas set Estado = 0 where IDModulo = @IDModulo

		commit transaction
	end try
	begin catch
		rollback transaction
		raiserror('TODO MAL',16,1)
	end catch
end

/*
delete Modulos where ID = 1
select * from Tareas where IDModulo = 1
*/

/*
6) Hacer un trigger que al borrar un proyecto realice una baja 
lógica del mismo en lugar de una baja física. Además, debe 
borrar todas los módulos asociados al proyecto.
*/

create trigger TR_BAJA_LOGICA_PROYECTO_Y_MODULOS on Proyectos
instead of delete
as
begin
	begin try
		begin transaction
			declare @IDProyecto varchar(5)
			set @IDProyecto = (select ID from deleted)
			
			update Proyectos set Estado = 0 where ID = @IDProyecto
			
			update Modulos set Estado = 0 where IDProyecto = @IDProyecto

		commit transaction
	end try
	begin catch
		rollback transaction
		raiserror('TODO MAL',16,1)
	end catch
end

/*
delete Proyectos where ID = 'A100'
select * from Proyectos where ID = 'A100'
select * from Modulos where IDProyecto = 'A100'
*/

/*
7) Hacer un trigger que si se agrega una tarea cuya fecha de 
fin es mayor a la fecha estimada de fin del módulo asociado 
a la tarea entonces se modifique la fecha estimada de fin en 
el módulo.
*/
create trigger TR_MODIFICACION_FECHA_MODULO on Tareas
after insert
as
begin
	declare @IDTarea int = (select ID from inserted)
	declare @IDModuloIngresado int = (select IDModulo from inserted)
	declare @FechaFinTarea date = (select FechaFin from inserted)
	declare @FechaEstimadaFinModulo date = (select M.FechaEstimadaFin 
											from Modulos M 
											inner join Tareas T on M.ID = T.IDModulo
											where T.ID = @IDTarea)
	if @FechaFinTarea > @FechaEstimadaFinModulo
	begin
		update Modulos set FechaEstimadaFin = @FechaFinTarea where ID = @IDModuloIngresado
	end
end

/*
insert into Tareas(IDModulo, IDTipo, FechaInicio, FechaFin, Estado)
			values(1, 10, '2020-05-24', '2020-06-02', 1)

select * from Modulos where ID = 1
*/

/*
8) Hacer un trigger que al borrar una tarea que previamente se 
ha dado de baja lógica realice la baja física de la misma.
*/

create trigger TR_BAJA_FISICA_TAREA on Tareas
instead of delete
as
begin
	declare @IDTarea int = (select ID from deleted)
	declare @Estado bit = (select T.Estado from Tareas T where T.ID = @IDTarea)
	if @Estado = 0
	begin
		delete Tareas where ID = @IDTarea
	end
	else
		update Tareas set Estado = 0 where ID = @IDTarea
end

/*
delete Tareas where ID = 257
update Tareas set Estado = 1 where ID = 257
select * from Tareas where ID = 257
*/

/*
9) Hacer un trigger que al ingresar una colaboración no permita 
que el colaborador/a superponga las fechas con las de otras 
colaboraciones que se les hayan asignado anteriormente. En caso 
contrario, registrar la colaboración sino generar un error con 
un mensaje aclaratorio.
*/

Create Trigger TR_NO_SUPERPONER_COLABORACION on Colaboraciones
after insert
as
begin
        Declare @IDColab bigint
        Declare @IDTarea bigint
        Declare @Inicio date
        Declare @Fin date
        Declare @Cantidad smallint

        select @IDColab = IDColaborador, @IDTarea = IDTarea from inserted
        select @Inicio = FechaInicio, @Fin = FechaFin from Tareas where ID = @IDTarea

        -- Obtener datos necesarios de inserted
        Select @Cantidad = count(*) From Colaboraciones C
        inner join Tareas T on T.ID = C.IDTarea
        where C.IDColaborador = @IDColab and
        (
            @Inicio Between FechaInicio And FechaFin or 
            @Fin Between FechaInicio and FechaFin or
            @Inicio < FechaInicio And @Fin > FechaFin
        ) 
        
        if @Cantidad > 1
		begin
            rollback transaction
            raiserror('La tarea ingresada en la colaboración, se superpone con otras', 16, 1)
        end
end

/*
10) Hacer un trigger que al modificar el precio hora base de un 
tipo de tarea registre en una tabla llamada HistorialPreciosTiposTarea 
el ID, el precio antes de modificarse y la fecha de modificación.
NOTA: La tabla debe estar creada previamente. NO crearla dentro del trigger.
*/

create table HistorialPreciosTiposTarea(
	ID int primary key not null,
	PrecioPrevio money null,
	FechaModificado date null
)

create trigger TR_MODIFICAR_PRECIOHORA_TIPOSTAREA on TiposTarea
instead of update
as
begin
	declare @IDTipoTarea smallint = (select ID from inserted)
	declare @PrecioTipoTareaAnterior money = (select PrecioHoraBase from deleted)
	declare @PrecioTipoTareaNuevo money = (select PrecioHoraBase from inserted)

	if @PrecioTipoTareaNuevo <> @PrecioTipoTareaAnterior
	begin
		declare @FechaModificado date = getdate()
		
		declare @Bandera bit = (select count(*) from HistorialPreciosTiposTarea where @IDTipoTarea = ID)
		
		if @Bandera = 0
		begin
			insert into HistorialPreciosTiposTarea(ID, PrecioPrevio, FechaModificado)
					values(@IDTipoTarea, @PrecioTipoTareaAnterior, @FechaModificado)
		end
		if @Bandera = 1
		begin
			update HistorialPreciosTiposTarea set PrecioPrevio = @PrecioTipoTareaAnterior, FechaModificado = @FechaModificado where ID = @IDTipoTarea
		end

		update TiposTarea set PrecioHoraBase = (select PrecioHoraBase from inserted) where ID = @IDTipoTarea
	end
end

/*
update TiposTarea set PrecioHoraBase = 4000 where ID = 2
select * from TiposTarea where ID = 2
*/