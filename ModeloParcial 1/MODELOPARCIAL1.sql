use MODELOPARCIAL1
GO
--1) Apellido y nombres de los pacientes cuya cantidad de turnos de 'Protologia' sea mayor a 2.
select P.APELLIDO + ', ' + P.NOMBRE as 'Paciente'
from PACIENTES as P
WHERE (select distinct count(T.IDTURNO) from PACIENTES as PA
inner join TURNOS as T on PA.IDPACIENTE = T.IDPACIENTE
inner join MEDICOS as M on T.IDMEDICO = M.IDMEDICO
inner join ESPECIALIDADES as E on M.IDESPECIALIDAD = E.IDESPECIALIDAD
WHERE E.NOMBRE = 'PROCTOLOGIA' AND PA.IDPACIENTE = P.IDPACIENTE) > 2
GO

--2) Los apellidos y nombres de los médicos (sin repetir) que hayan 
--demorado en alguno de sus turnos menos de la duración promedio de turnos.
select distinct M.APELLIDO + ', ' + M.NOMBRE 'Medico' from MEDICOS M
inner join TURNOS T on M.IDMEDICO = T.IDMEDICO
where T.DURACION
< (select avg(T.DURACION) from TURNOS T)
GO

--3) Por cada paciente, el apellido y nombre y la cantidad de turnos realizados 
--en el primer semestre y la cantidad de turnos realizados en el segundo semestre. Indistintamente del año.
select P.APELLIDO + ', ' + P.NOMBRE AS 'Paciente', 
    (select count(T.IDTURNO) from PACIENTES AS PA
    inner join TURNOS AS T on PA.IDPACIENTE = T.IDPACIENTE
    where month(T.FECHAHORA) <= 6 and PA.IDPACIENTE = P.IDPACIENTE) as 'Primer Semestre',
    (select count(T.IDTURNO) from PACIENTES AS PA
    inner join TURNOS AS T on PA.IDPACIENTE = T.IDPACIENTE
    where month(T.FECHAHORA) > 6 and PA.IDPACIENTE = P.IDPACIENTE) as 'Segundo Semestre'
    from PACIENTES AS P
GO

--4) Los pacientes que se hayan atendido más veces en el año 
--2000 que en el año 2001 y a su vez más veces en el año 
--2001 que en año 2002.
select P.APELLIDO + ', ' + P.NOMBRE Paciente from PACIENTES P
	where (select count(T.IDTURNO) from TURNOS T 
	inner join PACIENTES PA on PA.IDPACIENTE = T.IDPACIENTE
	where P.IDPACIENTE = T.IDPACIENTE AND YEAR(T.FECHAHORA) = 2000) 
	> 
	(select count(T.IDTURNO) from TURNOS T 
	inner join PACIENTES PA on PA.IDPACIENTE = T.IDPACIENTE
	where P.IDPACIENTE = T.IDPACIENTE AND YEAR(T.FECHAHORA) = 2001) 
	and 
	(select count(T.IDTURNO) from TURNOS T 
	inner join PACIENTES PA on PA.IDPACIENTE = T.IDPACIENTE
	where P.IDPACIENTE = T.IDPACIENTE AND YEAR(T.FECHAHORA) = 2001) 
	> 
	(select count(T.IDTURNO) from TURNOS T 
	inner join PACIENTES PA on PA.IDPACIENTE = T.IDPACIENTE
	where P.IDPACIENTE = T.IDPACIENTE AND YEAR(T.FECHAHORA) = 2002)
GO