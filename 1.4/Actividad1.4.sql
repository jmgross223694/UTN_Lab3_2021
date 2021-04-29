use BluePrint
GO
create table Modulos(
	ID int not null primary key identity(1,1),
	Nombre varchar(50) not null,
	Descripcion varchar(500) null,
	DuracionEstimadaHS smallint not null check(DuracionEstimadaHS > 0),
	Costo money not null check(Costo > 0),
	FechaInicio date null,
	FechaEstimadaFin date null,
	FechaRealFin date null,
	ID_Proyecto varchar(5) not null foreign key references Proyectos(ID)
)
GO
create table Paises(
	ID smallint primary key identity(1,1) not null,
	Nombre varchar(50) not null
)
GO
create table Ciudades(
	ID smallint primary key identity(1,1) not null,
	Nombre varchar(100) not null,
	IDPais smallint not null foreign key references Paises(ID)
)
GO
create table Colaboradores(
	ID int not null primary key identity(1,1),
	Apellidos varchar(50) not null,
	Nombres varchar(50) not null,
	Mail varchar(200) null, 
	Celular varchar(50) null,
	FechaNacimieto date not null check(FechaNacimieto < GETDATE()),
	Domicilio varchar(200) null,
	IDCiudad smallint null foreign key references Ciudades(ID),
	Tipo char(1) not null check(Tipo='I' or Tipo='E'),
	CONSTRAINT CHK_MAIL_CELULAR CHECK(Mail is not null or Celular is not null)
)
GO
ALTER TABLE Proyectos add constraint CHK_FechaFin check(FechaFin >= FechaInicio)
GO