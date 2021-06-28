-- Modelo 1:

/*
1) Hacer un trigger que al cargar un crédito verifique que el 
importe del mismo sumado a los importes de los créditos que actualmente 
solicitó esa persona no supere al triple de la declaración de ganancias. 
Sólo deben tenerse en cuenta en la sumatoria los créditos que no se 
encuentren cancelados. De no poder otorgar el crédito aclararlo con un mensaje.
*/
use ModeloParcial2
GO

create trigger tr_verificar_carga_de_credito on Creditos
after insert
as
begin
	--sumar solo creditos no cancelados
	declare @DNI bigint
	select @DNI = DNI from inserted
	
	declare @importeCreditoNuevo money
	declare @importesCreditosVigentes money
	declare @importeTotal money
	declare @ganancias money
	
	select @importeCreditoNuevo = Importe from inserted
	
	set @importesCreditosVigentes = (select isnull(sum(C.Importe), 0) from Creditos C where Cancelado = 0 and C.DNI = @DNI)
	
	set @importeTotal = @importeCreditoNuevo + @importesCreditosVigentes
	
	select @ganancias = P.DeclaracionGanancias from Personas P where P.DNI = @DNI
	
	set @ganancias = @ganancias*3

	--verificar que (importe + creditos vigentes) < (3 * ganancias)

	if @importeTotal >= @ganancias begin
			raiserror('No se puede otorgar el credito', 16, 1)
		end

		else

		begin
			insert into Creditos(ID, IDBanco, DNI, Fecha, Importe, Plazo, Cancelado) 
			select ID, IDBanco, DNI, Fecha, Importe, Plazo, Cancelado from inserted
			--commit transaction
		end
end
GO

/*
SET IDENTITY_INSERT Creditos ON

insert into Creditos(ID, IDBanco, DNI, Fecha, Importe, Plazo, Cancelado) 
values (6, 2, 4444, cast(N'2021-06-14' as date), 50000, 19, 0)

delete Creditos where ID in(6,7)

select getdate()

select * from Creditos
select * from Bancos
select * from Personas
*/

/*
2) Hacer un trigger que al eliminar un crédito realice la cancelación del mismo.
*/
use ModeloParcial2
GO
create trigger tr_cancelar_credito on Creditos
instead of delete
as
begin
	--cambiar atributo de credito Cancelado a 1
	declare @ID bigint
	select @ID = ID from deleted
	UPDATE Creditos set Cancelado = 1 where ID = @ID	
end
GO

--delete Creditos where ID = 4


/*
3) Hacer un trigger que no permita otorgar créditos con un plazo de 20 o más años a 
personas cuya declaración de ganancias sea menor al promedio de declaración de ganancias.
*/

use ModeloParcial2
GO

alter trigger tr_verificar_ganancias on Creditos
instead of insert
as
begin
	--preguntar si el plazo es menor a 20 años
	declare @Plazo smallint
	select @Plazo = Plazo from inserted
	--calcular promedio de declaracion de ganancias
	declare @promedioGanancias money
	declare @DNI bigint
	select @DNI = DNI from inserted
	set @promedioGanancias = (select isnull(avg(P.DeclaracionGanancias), 0) from Personas P)
	declare @gananciaPersona money
	set @gananciaPersona = (select P.DeclaracionGanancias from Personas P where P.DNI = @DNI)

	if @Plazo >= 20 
	begin
		if @gananciaPersona < @promedioGanancias
		begin
			raiserror('No se puede otorgar el credito', 16, 1)
		end

		else

		begin
			insert into Creditos(ID, IDBanco, DNI, Fecha, Importe, Plazo, Cancelado) 
			select ID, IDBanco, DNI, Fecha, Importe, Plazo, Cancelado from inserted
			--commit transaction
		end
	end
end
GO

/*
insert into Creditos(ID, IDBanco, DNI, Fecha, Importe, Plazo, Cancelado) 
values (6, 2, 4444, cast(N'2021-06-14' as date), 1, 20, 0)

select * from Creditos

delete Creditos where ID in(6, 7)
*/

/*
4) Hacer un procedimiento almacenado que reciba dos fechas y liste todos los créditos 
otorgados entre esas fechas. Debe listar el apellido y nombre del solicitante, el 
nombre del banco, el tipo de banco, la fecha del crédito y el importe solicitado.
*/
create procedure mostrar_prestamos_por_rango_de_fechas(
	@fechaInicio date,
	@fechaFin date
)
as
begin
select P.Apellidos + ', ' + P.Nombres as Solicitante, B.Nombre as Banco, B.Tipo as 'Tipo de banco', 
	   C.Fecha as 'Fecha de credito', C.Importe as 'Importe solicitado'
	   from Personas P
	   inner join Creditos C on P.DNI = C.DNI
	   inner join Bancos B on C.IDBanco = B.ID
	   where C.Fecha >= @fechaInicio and C.Fecha < @fechaFin
	   order by C.Fecha desc
end
GO

exec mostrar_prestamos_por_rango_de_fechas '2020-12-12', '2021-01-12'


--_____________________________________________________________________________________________________________

-- Modelo 2:

/*
A) - Realizar un trigger que se encargue de verificar que un socio 
no pueda extraer más de un libro a la vez. Se sabrá que un socio 
tiene un libro sin devolver si contiene un registro en la tabla de 
Préstamos que no tiene fecha de devolución. Si el socio tiene un 
libro sin devolver el trigger no deberá permitir el préstamo y 
deberá indicarlo con un mensaje aclaratorio. Caso contrario, 
registrar el préstamo.  (25 puntos)
*/

--contar cantidad de prestamos para x persona sin fecha de devolucion

create trigger tr_verificar_prestamos_pendientes on Prestamos
instead of insert
as begin

    declare @IDSocio bigint
    select @IDSocio = IDSocio from inserted
    declare @CantDevPend int
    set @CantDevPend = (select count(*) from Prestamos as P where P.IDSocio = @IDSocio and P.FDevolucion is null)
    if @CantDevPend = 0
    begin        
		insert into Prestamos (IDSocio, IDLibro, FPrestamo, FDevolucion, Costo)
		select IDSocio, IDLibro, FPrestamo, FDevolucion, Costo from inserted
    end
    
    if @CantDevPend > 0 
    begin
        raiserror('No se puede otorgar el préstamo', 16, 1)
    end
end

/*
B) Realizar un procedimiento almacenado que a partir de un número 
de socio se pueda ver, ordenado por fecha decreciente, todos los 
libros retirados por el socio y que hayan sido devueltos. (20 puntos)
*/

create procedure sp_libros_retirados(
	@IDSocio bigint
)
as 
begin
	select * from Libros L
	inner join Prestamos P on L.ID = P.IDLibro
	inner join Socios S on P.IDSocio = S.ID
	where S.ID = @IDSocio and FDevolucion is not null
	order by FPrestamo desc
end

/*
C) Hacer un procedimiento almacenado denominado 'Devolver_Libro' 
que a partir de un IDLibro y una Fecha de devolución, realice la 
devolución de dicho libro en esa fecha y asigne el costo del 
préstamo que equivale al 10% del valor del libro. Si el libro es 
devuelto después de siete días o más de la fecha de préstamo, el 
costo del préstamo será del 20% del valor del libro.
NOTA: Si el libro no se encuentra prestado indicarlo con un 
mensaje. (30 puntos)
*/

create procedure sp_Devolver_Libro(
	@IDLibro bigint
)
as
begin
	declare @FDevolucion date = getdate()
	declare @DiasPrestamo int = (getdate() - (select P.FPrestamo from Prestamos P where @IDLibro = P.IDLibro))
	if (select count(*) from Prestamos P where P.IDLibro = @IDLibro) = 0
	begin
		raiserror ('EL LIBRO NO SE ENCUENTRA PRESTADO!',16,1)
	end
	if @DiasPrestamo >= 7
	begin
		declare @NuevoCosto money = (select L.Precio*0.2 from Libros L where L.ID = @IDLibro)
		update Prestamos set P.FDevolucion = @FDevolucion, P.Costo = @NuevoCosto where @IDLibro = P.IDLibro
	end
	else
	begin
		declare @NuevoCosto money = (select L.Precio*0.1 from Libros L where L.ID = @IDLibro)
		update Prestamos set P.FDevolucion = @FDevolucion, P.Costo = @NuevoCosto where @IDLibro = P.IDLibro
	end
end

exec sp_Devolver_Libro IDLibro, FechaDevolucion

/*
D) Listar todos los socios que hayan retirado al menos un bestseller. 
Los datos del socio deben aparecer una sola vez en el listado. (25 puntos)
*/

select distinct * from Socios S
inner join Prestamos P on S.ID = P.IDSocio
inner join Libros L on P.IDLibro = L.ID
where L.Bestseller = 1
GO