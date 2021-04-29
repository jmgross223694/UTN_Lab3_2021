create database Actividad1.2_1aN
GO
use Actividad1.2_1aN
GO
/*
Relación 1 - N: 
Este ejemplo trata sobre un sistema de gestión de productos de tipo textil, 
con modalidad de venta e-commerce, en el cual existen productos que contienen
sub-productos en los que se especifica color y talle.
*/
create table Productos(
	productID bigint not null primary key identity(1000,1),
	nombre varchar(30) not null,
	descripcion varchar(100) not null,
	proveedor varchar(30) not null,
	precio money not null,
	marca varchar(30) not null
)
GO
create table SubProductos(
	skuID bigint not null primary key identity(1000,1),
	productID bigint not null foreign key references Productos(productID),
    color varchar(20) null,
    talle varchar(5) null check(talle='1' or talle='2' or talle='3' or talle='S' or talle='M' or talle='L')
)
GO
