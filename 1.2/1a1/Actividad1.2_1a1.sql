create database Actividad1.2_1a1
GO
use Actividad1.2_1a1
GO
/*
Relación 1 - 1: 
Este ejemplo trata sobre una agencia de autos que enlaza el código de auto con la tabla
"Promociones" en la que se detalla el precio de la unidad, junto a su financiación.
*/
create table Vehiculos(
    codigoAuto bigint not null primary key identity(1000,1),
    marca varchar(30) not null,
    modelo varchar(30) not null,
    color varchar(20) not null,
    kms bigint not null check (kms >= 0)
)
GO
create table Promociones(
    codigoAuto bigint not null primary key foreign key references Vehiculos(codigoAuto),
    precioPromocional money not null check (precioPromocional >= 90000),
    cantidadCuotas int not null check (cantidadCuotas >= 12 and cantidadCuotas <= 84),
    banco varchar(30) not null
)
GO