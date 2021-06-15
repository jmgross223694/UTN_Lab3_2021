--1)
use parcial1
select Tec.Apellido + ', ' + Tec.Nombre as Tecnico
from Tecnicos as Tec
inner join Servicios as Serv on Tec.ID = Serv.IDTecnico
inner join Clientes as CL on Serv.IDCliente = CL.ID
group by Tec.Apellido, Tec.Nombre
having (select count(CL.ID)) > 20
GO

--2)
use parcial1
select distinct CL.ID as IDCliente, CL.Apellido + ', ' + CL.Nombre as Cliente
from Clientes as CL
inner join Servicios as Serv on CL.ID = Serv.IDCliente
inner join TiposServicio as TS on Serv.IDTipo = TS.ID
where year(Serv.Fecha) = 2020 AND TS.Descripcion <> 'Reparacion de lavarropas'
GO

--3)
use parcial1
select distinct CL.Apellido + ', ' + CL.Nombre as 'Cliente', 
(select count(Serv2.ID) 
from Servicios as Serv2
where Serv2.IDCliente = CL.ID AND Serv2.DiasGarantia > 0) as ConGarantia,
(select count(Serv2.ID) 
from Servicios as Serv2
where Serv2.IDCliente = CL.ID AND Serv2.DiasGarantia = 0) as SinGarantia
from Clientes as CL
inner join Servicios as Serv on CL.ID = Serv.IDCliente
GO

--4)
use parcial1
select distinct Tec.Apellido + ', ' + Tec.Nombre as Tecnico
from Tecnicos as Tec
inner join Servicios as Serv on Tec.ID = Serv.IDTecnico
where 
(select sum(Serv2.Importe) from Servicios as Serv2 where Serv2.FormaPago = 'T' AND Tec.ID = Serv2.IDTecnico) 
> 
(select sum(Serv2.Importe) from Servicios as Serv2 where Serv2.FormaPago = 'E' AND Tec.ID = Serv2.IDTecnico) 
AND 
(select sum(Serv2.Importe) from Servicios as Serv2 where Serv2.FormaPago = 'E' AND Tec.ID = Serv2.IDTecnico) 
> 
((select sum(Serv2.Importe) from Servicios as Serv2 where Serv2.FormaPago = 'T' AND Tec.ID = Serv2.IDTecnico)*0.5)
GO

--5)
use parcial1
create table Insumos(
ID int primary key identity(1,1),
IDServicio int not null foreign key references Servicios(ID),
Descripcion varchar(100) not null,
Costo money not null,
Origen char not null check(Origen='I' OR Origen='N')
)
GO