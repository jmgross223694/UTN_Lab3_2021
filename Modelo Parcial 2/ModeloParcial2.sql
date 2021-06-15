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
	
	select @ganancias = P.DeclaracionGanancias from Personas P where DNI = @DNI
	
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
	select @promedioGanancias = (select isnull(avg(P.DeclaracionGanancias), 0) from Personas P)
	declare @gananciaPersona money
	select @gananciaPersona = (select P.DeclaracionGanancias from Personas P where P.DNI = @DNI)

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
