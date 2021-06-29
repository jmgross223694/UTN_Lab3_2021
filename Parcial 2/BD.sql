Create Database Parcial2
go
Use Parcial2
go
Create Table Especies(
    ID bigint not null primary key identity(1, 1),
    Nombre varchar(30) not null,
    PesoMinimo decimal(5, 2) not null check (PesoMinimo > 0)
)
go
Create Table Competidores(
    ID bigint not null primary key identity(1, 1),
    Apellido varchar(50) not null,
    Nombre varchar(50) not null,
    AñoNacimiento smallint not null
)
go
Create Table Torneos(
    ID bigint not null primary key identity(1, 1),
    Nombre varchar(100) not null,
    Año smallint not null,
    Ciudad varchar(50) not null,
    Inicio datetime not null,
    Fin datetime not null,
    Premio money not null check (Premio > 0),
    CapturasPorCompetidor smallint not null check (CapturasPorCompetidor > 0)
)
go
Create Table Capturas(
    ID bigint not null primary key identity (1, 1),
    IDCompetidor bigint not null foreign key references Competidores(ID),
    IDTorneo bigint not null foreign key references Torneos(ID),
    IDEspecie bigint not null foreign key references Especies(ID),
    FechaHora datetime not null,
    Peso decimal(5, 2) not null check (Peso > 0),
    Devuelta bit not null default(0)
)
go
-- Especies
Insert into Especies(Nombre, PesoMinimo) Values ('Esturión', 5)
Insert into Especies(Nombre, PesoMinimo) Values ('Barbo', 1.2)
Insert into Especies(Nombre, PesoMinimo) Values ('Atún blanco', 2.5)
Insert into Especies(Nombre, PesoMinimo) Values ('Carpa', 5.5)
Insert into Especies(Nombre, PesoMinimo) Values ('Pez gato', 7)
Insert into Especies(Nombre, PesoMinimo) Values ('Pez globo', 8)
Insert into Especies(Nombre, PesoMinimo) Values ('Tilapia', 4)
Insert into Especies(Nombre, PesoMinimo) Values ('Trucha tigre', 3.5)

-- Competidores
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Hargraves', 'Donni', 1940);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Hindenberger', 'Robers', 1991);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Hambribe', 'Nancee', 1969);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Dunning', 'Charlton', 1966);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('MacHostie', 'Stevena', 1963);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Gookes', 'Charleen', 1993);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Dawks', 'Aloysius', 1975);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Petrovykh', 'Rinaldo', 1968);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Leas', 'Madelyn', 1963);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Saggs', 'Terri', 1980);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Grabert', 'Alvis', 1974);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Forson', 'Drusie', 1977);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Oaks', 'Olly', 1960);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Golley', 'Haydon', 1968);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Spurdens', 'Maury', 1994);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('McIlveen', 'Abigail', 1972);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Styles', 'Melantha', 1995);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Huyge', 'Twila', 1973);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Julyan', 'Elaine', 1994);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Syfax', 'Brooks', 1976);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Shubotham', 'Van', 1998);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Hourston', 'Rockwell', 1967);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Curner', 'Enoch', 1966);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Lazell', 'Mitzi', 1982);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('McMechan', 'Shae', 1963);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Jobling', 'Rebekkah', 1999);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Hercock', 'Fonz', 2000);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('McMylor', 'Esme', 1968);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Lilley', 'Adi', 1988);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Rosoni', 'Karon', 1974);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Fillgate', 'Osborne', 1999);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Hellier', 'Karel', 2001);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Feldberg', 'Garfield', 1996);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Stable', 'Farica', 1986);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Duke', 'Carolynn', 1991);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('O''Sherin', 'Ursula', 1974);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Atheis', 'Coletta', 1961);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Bernot', 'Zebulon', 1999);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Bate', 'Yardley', 1993);
insert into Competidores (Apellido, Nombre, AñoNacimiento) values ('Haet', 'Madlen', 1961);

-- Torneos
Set Dateformat 'DMY'
Insert into Torneos (Nombre, Año, Ciudad, Inicio, Fin, Premio, CapturasPorCompetidor)
Values ('Gran premio de Buenos Aires', 2018, 'Buenos Aires', '15/01/2018', '17/01/2018', 500000, 7)
Insert into Torneos (Nombre, Año, Ciudad, Inicio, Fin, Premio, CapturasPorCompetidor)
Values ('Gran premio de Nueva York', 2019, 'Nueva York', '1/05/2019', '1/06/2019', 500000, 3)
Insert into Torneos (Nombre, Año, Ciudad, Inicio, Fin, Premio, CapturasPorCompetidor)
Values ('European Trophy 2016', 2016, 'Madrid', '15/01/2016', '25/01/2016', 700000, 10)
Insert into Torneos (Nombre, Año, Ciudad, Inicio, Fin, Premio, CapturasPorCompetidor)
Values ('European Trophy 2017', 2017, 'Vik', '15/01/2017', '25/01/2017', 700000, 10)
Insert into Torneos (Nombre, Año, Ciudad, Inicio, Fin, Premio, CapturasPorCompetidor)
Values ('European Trophy 2020', 2020, 'Berlin', '15/01/2020', '25/01/2020', 700000, 10)
Insert into Torneos (Nombre, Año, Ciudad, Inicio, Fin, Premio, CapturasPorCompetidor)
Values ('European Trophy 2021', 2021, 'Londres', '15/01/2021', '25/01/2021', 700000, 10)
