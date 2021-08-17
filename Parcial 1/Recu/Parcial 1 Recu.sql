use Examen
/*
1) Por cada cami�n, listar el ID, el a�o de patentamiento y la cantidad de viajes que 
hayan superado la mitad del peso l�mite en concepto de peso de paquetes.
*/

select Ca.ID ID, Ca.A�oPatentamiento 'A�o Patentamiento', 
(select count(V.ID) from Viajes V 
where V.IDCamion = Ca.ID 
and 
(select sum(P.Peso) from Paquetes P where P.IDViaje = V.ID)
> 
Ca.PesoLimite/2) CantViajes
from Camiones Ca
GO

/*
2) Los apellidos y nombres de los choferes que hayan utilizado m�s de tres camiones distintos.
*/

select Ch.Apellidos + ', ' + Ch.Nombres Chofer from Choferes Ch
where (select distinct count(Ca.ID) from Camiones Ca
		inner join Viajes V on Ca.ID = V.IDCamion
		inner join Choferes C on V.IDChofer = C.ID
		where C.ID = Ch.ID) 
		> 3
GO

/*
3)	Listar apellido y nombres de los choferes que hayan enviado m�s paquetes con 
alimentos que paquetes sin alimentos.
*/

select Ch.Apellidos + ', ' + Ch.Nombres Chofer from Choferes Ch
where	(select count(P.ID) from Paquetes P
		inner join Viajes V on P.IDViaje = V.ID
		inner join Choferes C on V.IDChofer = C.ID
		where P.Alimento = 1 and Ch.ID = C.ID)
		>
		(select count(P.ID) from Paquetes P
		inner join Viajes V on P.IDViaje = V.ID
		inner join Choferes C on V.IDChofer = C.ID
		where P.Alimento = 0 and Ch.ID = C.ID)
GO
/*
4)	Por cada viaje, listar el ID del viaje, el apellido y nombre del chofer, 
el ID del cami�n y el porcentaje de ocupaci�n del cami�n 
(Total de kilos transportados en el viaje/Peso l�mite del cami�n)*100.
*/

select distinct V.ID ID, 
	(select Ch.Apellidos + ', ' + Ch.Nombres from Choferes Ch where Ch.ID = V.IDChofer) Chofer,
	(select Ca.ID from Camiones Ca where Ca.ID = V.IDCamion) 'ID Cami�n',
	str(isnull((select (select sum(P.Peso) from Paquetes P where P.IDViaje = V.ID)*1.0/
	(select C.PesoLimite from Camiones C where C.ID = V.IDCamion)*100),0),2) + '%' 'Ocupaci�n cami�n'
	from Viajes V
GO