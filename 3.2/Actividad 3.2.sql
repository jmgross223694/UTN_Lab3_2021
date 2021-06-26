use BluePrint
GO
/*
1) Hacer un trigger que al ingresar una colaboraci�n obtenga 
el precio de la misma a partir del precio hora base del tipo 
de tarea. Tener en cuenta que si el colaborador es externo 
el costo debe ser un 20% m�s caro.
*/
alter trigger TR_PRECIO_COLABORACION on Colaboraciones
after insert
as
begin
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
	update Colaboraciones set PrecioHora = @CostoColaboracion where IDTarea = IDTarea
end

insert into Colaboraciones(IDTarea, IDColaborador, Tiempo, PrecioHora, Estado)
			values (7, 1, 10, 0, 1)

delete from Colaboraciones where IDTarea = 7

select * from Colaboraciones where IDTarea = 7

/*
2) Hacer un trigger que no permita que un colaborador registre 
m�s de 15 tareas en un mismo mes. De lo contrario generar un 
error con un mensaje aclaratorio.
*/

/*
3) Hacer un trigger que al ingresar una tarea cuyo tipo contenga 
el nombre 'Programaci�n' se agreguen autom�ticamente dos tareas 
de tipo 'Testing unitario' y 'Testing de integraci�n' de 4 horas 
cada una. La fecha de inicio y fin de las mismas debe ser NULL.
Calcular el costo estimado de la tarea.
*/

/*
4) Hacer un trigger que al borrar una tarea realice una baja 
l�gica de la misma en lugar de una baja f�sica.
*/

/*
5) Hacer un trigger que al borrar un m�dulo realice una baja 
l�gica del mismo en lugar de una baja f�sica. Adem�s, debe 
borrar todas las tareas asociadas al m�dulo.
*/

/*
6) Hacer un trigger que al borrar un proyecto realice una baja 
l�gica del mismo en lugar de una baja f�sica. Adem�s, debe 
borrar todas los m�dulos asociados al proyecto.
*/

/*
7) Hacer un trigger que si se agrega una tarea cuya fecha de 
fin es mayor a la fecha estimada de fin del m�dulo asociado 
a la tarea entonces se modifique la fecha estimada de fin en 
el m�dulo.
*/

/*
8) Hacer un trigger que al borrar una tarea que previamente se 
ha dado de baja l�gica realice la baja f�sica de la misma.
*/

/*
9) Hacer un trigger que al ingresar una colaboraci�n no permita 
que el colaborador/a superponga las fechas con las de otras 
colaboraciones que se les hayan asignado anteriormente. En caso 
contrario, registrar la colaboraci�n sino generar un error con 
un mensaje aclaratorio.
*/

/*
10) Hacer un trigger que al modificar el precio hora base de un 
tipo de tarea registre en una tabla llamada HistorialPreciosTiposTarea 
el ID, el precio antes de modificarse y la fecha de modificaci�n.

NOTA: La tabla debe estar creada previamente. NO crearla dentro del trigger.
*/
