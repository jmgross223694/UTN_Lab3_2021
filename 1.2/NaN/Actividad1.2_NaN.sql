create database Actividad1.2_NaN
GO
use Actividad1.2_NaN
GO
/*
Relación N - N: 
En este ejemplo se crean dos tablas que son deportistas y deportes. 
Se crea una tabla adicional para detallar, que deportes practica cada deportista.
*/
create table Deportistas(
    dni bigint not null primary key,
    nombres varchar(50) not null,
    apellidos varchar(50) not null,
    fechaNacimiento date not null check (fechaNacimiento < getdate()),
    peso smallint not null check (peso > 0),
    altura smallint not null check (altura > 0)
)
GO
create table Deportes(
    ID bigint not null primary key identity(1,1),
    nombre varchar(30)
)
GO
create table DeportesPorDeportista(
    dni bigint not null foreign key references Deportistas(dni),
    ID bigint not null foreign key references Deportes(ID),
    añosDeExperiencia int not null check (añosDeExperiencia >= 0),
    primary key (dni, ID)
)
GO