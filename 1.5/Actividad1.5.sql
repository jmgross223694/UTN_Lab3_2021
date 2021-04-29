use BluePrint
GO
create table Tareas(
	ID int primary key identity(1,1),
	IDModulo int not null foreign key references Modulos(ID), --Debe pertenecer a un modulo
	Tipo char(1) not null,
	FechaInicio date null,
	FechaFin date null,
	Estado char not null check(Estado='A' or Estado='S') --A = Aceptada / S = Suspendida
)
GO
create table Colaboraciones(
	ID int not null primary key,
	IdTarea int not null foreign key references Tareas(ID),
	IdColaborador int not null foreign key references Colaboradores(ID),
	CantHoras smallint not null check(CantHoras > 0),
	ValorPorHora money not null check(ValorPorHora > 0),
	Estado char not null check(Estado='A' or Estado='S'), --A = Aceptada / S = Suspendida
	--Nos queda la duda si esta bien resuelta la condición "Una tarea puede ser realizada por muchos colaboradores".
	--Porque nos surgió la pregunta de si un colaborador puede o no tener muchas tareas.
)
GO