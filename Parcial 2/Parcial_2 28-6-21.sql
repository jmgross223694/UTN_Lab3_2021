use Parcial2
GO

--1)
create trigger TR_VERIFICAR_HORAS on Capturas
instead of insert
as
begin
	declare @FechaHora datetime = (select FechaHora from inserted)
	declare @IDTorneo bigint = (select IDTorneo from inserted)
	declare @HoraInicio datetime = (select T.Inicio from Torneos T
									where @IDTorneo = T.ID)
	declare @HoraFin datetime = (select T.Fin from Torneos T
	where @IDTorneo = T.ID)
	if @FechaHora between @HoraInicio and @HoraFin
	begin
		insert into Capturas(IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta)
		select IDCompetidor, IDTorneo, IDEspecie, FechaHora, Peso, Devuelta from inserted
	end
	else
	begin
		raiserror('LA CAPTURA FUE REALIZADA FUERA DEL HORARIO DEL TORNEO, NO SE PUEDE REGISTRAR',16,1)
	end
end
GO



--2)
create trigger TR_VERIFICAR_ANIO on Torneos
instead of insert
as
begin
	if (select A�o from inserted) > (select top 1 T.A�o from Torneos T inner join inserted i
			on T.Ciudad = i.Ciudad order by T.A�o desc)+5
	begin
		insert into Torneos(ID, Nombre, A�o, Ciudad, Inicio, Fin, Premio, CapturasPorCompetidor)
			select ID, Nombre, A�o, Ciudad, Inicio, Fin, Premio, CapturasPorCompetidor from inserted
	end
	else
	begin
		raiserror('NO SE PUEDE CARGAR EL TORNEO, YA QUE SE REALIZ� OTRO EN ESTA CIUDAD HACE 5 A�OS O MENOS',16,1)
	end
end
GO



--3)
create trigger TR_BAJA_CAPTURA on Capturas
instead of delete
as
begin
	declare @IDCaptura bigint = (select ID from deleted)
	if (select Devuelta from deleted) = 1
	begin
		delete Capturas where ID = @IDCaptura
	end
	else
	begin
		update Capturas set Devuelta = 1 where ID = @IDCaptura
	end
end
GO



--4)
create procedure SP_GANADOR_TORNEO(
	@IDTorneo bigint
)
as
begin

	select top 1 with ties COMP.Nombre + ', ' + COMP.Apellido 'Competidor',  
	(select sum(C.Peso) from Torneos T inner join Capturas C on T.ID = C.IDTorneo
	where T.ID = @IDTorneo and COMP.ID = C.IDCompetidor) 'Kilos acumulados',
	case 
    when (year(getdate())-COMP.A�oNacimiento) > 65
    then 'El viejo Santiago'
    when (year(getdate())-COMP.A�oNacimiento) between 23 and 65
    then 'Ilia Krusch'
    when (year(getdate())-COMP.A�oNacimiento) between 16 and 22
    then 'Manol�n'
    end as 'Categor�a'
	from Competidores COMP order by [Kilos acumulados] desc
		
end