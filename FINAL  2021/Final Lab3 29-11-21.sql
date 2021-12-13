--Punto 1:

/*
Realizar el script de creaci�n de Base de datos. 
Agregar todas las restricciones de tipo Primary Key, 
Foreign Key, Unique y Check que considere necesarias.
*/

create database FinalLab32021
GO

use FinalLab32021
GO

create table Clientes(
	ID bigint not null primary key identity(1,1),
	DNI varchar(15) unique not null,
	Apellidos varchar(100) not null,
	Nombres varchar(100) not null
)
GO

create table Localidades(
	ID bigint not null primary key identity(1,1),
	Nombre varchar(50) not null
)
GO

create table Salones(
	ID bigint not null primary key identity(1,1),
	Nombre varchar(50) not null,
	Domicilio varchar(140) not null,
	IDLocalidad bigint not null foreign key references Localidades(ID),
	Capacidad smallint not null check (Capacidad > 0),
	Costo money not null check (Costo > 0)
)
GO

create table Reservas(
	ID bigint not null primary key identity(1,1),
	IDCliente bigint not null foreign key references Clientes(ID),
	IDSalon bigint not null foreign key references Salones(ID),
	FechaReserva date not null check (FechaReserva >= getdate()),
	FechaEvento date not null unique check (FechaEvento >= getdate()),
	Asistentes smallint not null,
	Importe money not null check (Importe > 0),
	Adelanto money not null check (Adelanto > 0),
	Pagada bit not null
)
GO


--Punto 2:

/*Al insertar una reserva verifique que la cantidad de asistentes a la misma no 
supere la cantidad del sal�n y que dicho sal�n se encuentre disponible en esa fecha. 
Calcular el adelanto y el importe si es una reserva v�lida, de lo contrario mostrar 
un mensaje de error apropiado a la raz�n de porqu� no puede registrarse la reserva.*/

create or alter trigger TR_VERIFICAR_RESERVA on Reservas
instead of insert
as
begin
	declare @FechaEventoReserva date = (select FechaEvento from inserted)
	declare @IdSalon bigint = (select IDSalon from inserted)
	declare @Asistentes smallint = (select Asistentes from inserted)
	declare @CapacidadSalon smallint = (select Capacidad from Salones where ID = @IdSalon)
	declare @SalonReservado smallint = (select count(*) from Reservas where IDSalon = @IdSalon and FechaEvento = @FechaEventoReserva)
	declare @AdelantoPagado money = (select Adelanto from inserted)
	declare @CantDiasReserva int = (select datediff(day, FechaReserva, FechaEvento) from inserted)
	declare @ImporteAbonado money = (select Importe from inserted)
	declare @ImporteSalon money = (select Costo from Salones where ID = @IdSalon)
	declare @AdelanteCalculado money = (select Importe*0.1 from inserted)

	if (@CantDiasReserva <= 10)
		begin
			set @AdelanteCalculado = (select Importe*0.5 from inserted)
		end

	if (@SalonReservado > 0)
		begin
			RAISERROR('La reserva no se puede registrar debido a que el sal�n ya est� ocupado en esa fecha.',16,1)
		end

	if (@Asistentes > @CapacidadSalon)
		begin
			RAISERROR('La reserva no se puede registrar debido a que la cantidad de asistentes, supera la capacidad del sal�n.',16,1)
		end

	if (@SalonReservado = 0 and (@Asistentes <= @CapacidadSalon))
		begin
			insert into Reservas(IDCliente, IDSalon, FechaReserva, FechaEvento, Asistentes, Importe, Adelanto, Pagada)
			select IDCliente, IDSalon, FechaReserva, FechaEvento, Asistentes, Importe, @AdelanteCalculado, Pagada from inserted
		end
end
GO


--Punto 3:

/*
Hacer un ranking con los diez salones que m�s veces hayan sido reservados indicando el nombre del sal�n, 
el domicilio, el nombre de la localidad, la cantidad total de reservas y el total facturado por ese sal�n 
(tener en cuenta que si una reserva no fue pagada lo �nico que factur� el sal�n fue el adelanto, en cambio, 
si la reserva fue pagada lo que factur� el sal�n fue el importe).
*/

select top 10 S.Nombre 'Nombre Sal�n', S.Domicilio Domicilio, 
(select L.Nombre from Localidades L where L.ID = S.IDLocalidad) Localidad,
(select count(*) from Reservas R where R.IDSalon = S.ID) 'Cantidad total de reservas',
(select isnull(sum(Re.Importe),0) from Reservas Re where Re.IDSalon = S.ID and Re.Pagada = 1)
+
(select isnull(sum(Res.Adelanto),0) from Reservas Res where Res.IDSalon = S.ID and Res.Pagada = 0)
'Total facturado'
from Salones S
order by [Cantidad total de reservas] desc
GO


--Punto 4:

/*
Hacer un procedimiento almacenado que reciba una fecha y una cantidad de asistentes y 
muestre los salones disponibles para reservar. Indicar el nombre, la localidad y 
el costo de alquiler del sal�n.
*/

create or alter procedure SP_SALONES_DISPONIBLES(
	@Fecha date,
	@CantAsistentes smallint
)as
begin
	select S.Nombre 'Nombre Sal�n',
	(select L.Nombre from Localidades L where L.ID = S.IDLocalidad) Localidad,
	S.Costo 'Costo alquiler'	
	from Salones S
	where S.Capacidad >= @CantAsistentes
		and
		(select count(*) from Reservas R where R.FechaEvento = @Fecha) = 0
end
GO