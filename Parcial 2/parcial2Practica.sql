use Parcial2
GO
/*
/1) Hacer un trigger que al registrar una captura se verifique que la misma se haya
realizado durante el horario de Inicio y Fin del torneo a la que pertenece. En caso que
se encuentre fuera de ese rango indicarlo con un mensaje de error. De lo contrario,
registrar la captura./
*/

create trigger TR_VERIFICAR_CAPTURA on Capturas
instead of insert
as
begin
	declare @FechaHoraCaptura datetime = (select FechaHora from inserted)
	declare @IDTorneoCaptura bigint = (select IDTorneo from inserted)
	declare @Inicio datetime = (select Inicio from Torneos where ID = @IDTorneoCaptura)
	declare @Fin datetime = (select Fin from Torneos where ID = @IDTorneoCaptura)

	if (@FechaHoraCaptura between @Inicio and @Fin)
		begin
			insert into Capturas(IDCompetidor, IDEspecie, IDTorneo, Devuelta, FechaHora, Peso)
			select IDCompetidor, IDEspecie, IDTorneo, Devuelta, FechaHora, Peso from inserted
		end
	else
		begin
			RAISERROR('La captura fue realizada fuera del rango horario del torneo.',16,1)
		end
end
GO

/*
/2) Hacer un trigger que no permita que se carguen un torneo en la misma ciudad a
menos que hayan pasado m�s de 5 a�os (desde la �ltima vez que se realiz� un
torneo en esa ciudad). Si esto ocurre indicarlo con un mensaje de error. Caso
contrario, registrar el torneo.
NOTA: Se debe usar el campo A�o para la comprobaci�n./
*/

create trigger TR_VERIFICAR_FECHA_TORNEO on Torneos
instead of insert
as
begin

		declare @CiudadTorneo varchar(50) = (select Ciudad from inserted)
		declare @A�oTorneo smallint = (select A�o from inserted)
		declare @cantidadTorneosCiudad int = (select count(*) from Torneos where Ciudad = @CiudadTorneo)
		
		if (@cantidadTorneosCiudad = 0)
		begin
			insert into Torneos(Nombre, A�o, Inicio, Fin, Ciudad, Premio, CapturasPorCompetidor)
			select Nombre, A�o, Inicio, Fin, Ciudad, Premio, CapturasPorCompetidor from inserted
		end
		else
		begin
			declare @UltimoA�oTorneo smallint = 
			(select Top 1 A�o from Torneos where Ciudad = @CiudadTorneo ORDER BY A�o DESC)

			if ((@A�oTorneo-@UltimoA�oTorneo) > 5)
				begin
					insert into Torneos(Nombre, A�o, Inicio, Fin, Ciudad, Premio, CapturasPorCompetidor)
					select Nombre, A�o, Inicio, Fin, Ciudad, Premio, CapturasPorCompetidor from inserted
				end
			else
				begin
					RAISERROR('Todav�a no pasaron m�s de 5 a�os del �ltimo torneo en la ciudad.',16,1)
				end
		end
end
GO

/*
/3) Hacer un trigger que al eliminar una captura sea marcada como devuelta y que al
eliminar una captura que ya se encuentra como devuelta se realice la baja f�sica del
registro./
*/

create trigger TR_ELIMINAR_CAPTURA on Capturas
instead of delete
as
begin
	declare @Devuelta bit = (select Devuelta from deleted)

	if (@Devuelta = 0)
		begin
			update Capturas set Devuelta = 1 where ID = (select ID from deleted)
		end
	else
		begin
			delete from Capturas where ID = (select ID from deleted)
		end
end
GO

/*
/4) Hacer un procedimiento almacenado que a partir de un IDTorneo indique los datos
del ganador del mismo. El ganador es aquel pescador que haya capturado la mayor
cantidad (en peso) de peces. Indicar Nombre, Apellido, Kilos acumulados y Categor�a
del pescador: ('El viejo Santiago' mayor a 65 a�os, 'Ilia Krusch' entre 23 y 65 a�os,
'Manol�n' entre 16 y 22 a�os).
NOTA: El primer puesto puede ser un empate entre varios competidores, en ese caso
mostrar la informaci�n de todos los ganadores./
*/

create procedure SP_GANADOR_TORNEO(
	@IDTorneo bigint
)as
begin
	select Top 1 with ties Comp.Nombre, Comp.Apellido, 
	(select sum(Cap.Peso) from Torneos T 
	inner join Capturas Cap on T.ID = Cap.IDTorneo
	where T.ID = @IDTorneo and Cap.IDCompetidor = Comp.ID)
	as 'Kilos acumulados',
	case
	when (year(Getdate()) - Comp.A�oNacimiento) > 65
	then 'El viejo Santiago'
	when (year(Getdate()) - Comp.A�oNacimiento) between 23 and 65
	then 'Ilia Krusch'
	when (year(Getdate()) - Comp.A�oNacimiento) between 16 and 22
	then 'Manol�n'
	end as 'Categor�a'
	
	from Competidores Comp order by [Kilos acumulados] desc
end
GO

insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta) values(1,1,1,'16/1/2018',5,0)
insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta) values(3,1,1,'16/1/2018',80,0)
insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta) values(2,1,2,'16/1/2018',1.2,0)
insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta) values(1,1,5,'16/1/2018',7,0)
insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta) values(2,1,7,'16/1/2018',4,0)
insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta) values(1,1,3,'16/1/2018',2.5,0)
insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta) values(1,1,6,'16/1/2018',8,0)
insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta) values(1,1,4,'16/1/2018',5.5,0)
insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta) values(1,1,7,'16/1/2018',4,0)
insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta) values(3,1,8,'16/1/2018',3.5,0)
insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta) values(3,1,2,'16/1/2018',1.2,0)
insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta) values(3,1,3,'16/1/2018',2.5,0)
