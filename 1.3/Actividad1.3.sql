create database BluePrint
GO
use BluePrint
GO
create table TipoClientes(
	ID int not null primary key identity(1,1),
	Tipo varchar(30) check(Tipo='Estatal' or Tipo='Multinacional' or Tipo='Educativo privado' or Tipo='Educativo público' or Tipo='Sin fines de lucro')
)
GO
create table Clientes(
	ID int identity(1,1) not null primary key,
	RazonSocial varchar(100) not null,
	cuit varchar(13) not null unique,
	IDTipoCliente int not null foreign key references TipoClientes(ID),
	Mail varchar(50) null,
	TelefonoFijo varchar(20) null,
	Celular varchar(20) null,
)
GO
create table Proyectos(
	ID varchar(5) not null primary key,
	Nombre varchar(50) not null,
	Descripcion varchar(400) null,
	IDCliente int not null foreign key references Clientes(ID),
	FechaInicio date not null,
	FechaFin date null,
	CostoEstimado money not null,
	Estado bit not null default (1)
)
GO