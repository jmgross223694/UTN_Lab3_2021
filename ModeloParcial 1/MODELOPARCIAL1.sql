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
select distinct M.APELLIDO + ', ' + M.NOMBRE as Medico
from MEDICOS as M
inner join TURNOS as T on M.IDMEDICO = T.IDMEDICO
WHERE T.DURACION < (select avg(TU.DURACION)
from TURNOS as TU)
GO

--3) Por cada paciente, el apellido y nombre y la cantidad de turnos realizados 
--en el primer semestre y la cantidad de turnos realizados en el segundo semestre. Indistintamente del año.
select PA.APELLIDO + ', ' + PA.NOMBRE as 'Paciente',
(select count(T.IDTURNO) from TURNOS AS T
where T.IDPACIENTE = PA.IDPACIENTE and MONTH(T.FECHAHORA) <= 6) as '1er Semestre',
(select count(T.IDTURNO) from TURNOS AS T
where T.IDPACIENTE = PA.IDPACIENTE and MONTH(T.FECHAHORA) > 6) as '2do Semestre'
from PACIENTES as PA
GO

--4) Los pacientes que se hayan atendido más veces en el año 
--2000 que en el año 2001 y a su vez más veces en el año 
--2001 que en año 2002.
select P.APELLIDO + ', ' + P.NOMBRE as 'Paciente' from Pacientes as P
where (select count(T.IDPACIENTE) from TURNOS AS T 
inner join PACIENTES AS PA on T.IDPACIENTE = PA.IDPACIENTE
WHERE YEAR(T.FECHAHORA) = 2000 AND T.IDPACIENTE = P.IDPACIENTE) >
(select count(T.IDPACIENTE) from TURNOS AS T 
inner join PACIENTES AS PA on T.IDPACIENTE = PA.IDPACIENTE
WHERE YEAR(T.FECHAHORA) = 2001 AND T.IDPACIENTE = P.IDPACIENTE)
AND (select count(T.IDPACIENTE) from TURNOS AS T 
inner join PACIENTES AS PA on T.IDPACIENTE = PA.IDPACIENTE
WHERE YEAR(T.FECHAHORA) = 2001 AND T.IDPACIENTE = P.IDPACIENTE) >
(select count(T.IDPACIENTE) from TURNOS AS T 
inner join PACIENTES AS PA on T.IDPACIENTE = PA.IDPACIENTE
WHERE YEAR(T.FECHAHORA) = 2002 AND T.IDPACIENTE = P.IDPACIENTE)
GO

select * from PACIENTES
select * from TURNOS
select * from 
