create database Actividad1
GO
use Actividad1
GO
create table Carreras(
	ID varchar(4) not null primary key,
	Nombre varchar(30) not null,
	Fecha_creacion date not null check (Fecha_creacion <= getdate()),
	Mail varchar(100) not null,
    Nivel varchar(11) not null check(Nivel='Diplomatura' or Nivel='Pregrado' or Nivel='Grado' or Nivel='Posgrado'),
)
GO
create table Alumnos(
	Legajo int not null primary key identity(100, 1),
	IDCarrera varchar(4) not null foreign key references Carreras(ID),
	Apellidos varchar(100) not null,
	Nombres varchar(100) not null,
	Nacimiento date not null check (Nacimiento <= getdate()),
	Mail varchar(50) not null unique,
	Telefono varchar(16) null
)
GO
create table Materias(
    ID int not null primary key identity(1, 1),
    IDCarrera varchar(4) not null foreign key references Carreras(ID),
    Nombre varchar(30) not null,
    CargaHoraria int not null check (CargaHoraria > 0)
)