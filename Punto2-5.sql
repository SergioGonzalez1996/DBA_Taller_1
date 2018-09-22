-- SEGUNDO PUNTO - CREAR 3 TABLESPACES
-- a) El primer Tablespaces con 2GB y un Datafile, su nombre debe ser Uber.
CREATE TABLESPACE Uber DATAFILE 'Uber01.dbf' SIZE 2G;

-- b) Undo Tablespace con 25MB de espacio y un Datafile.
CREATE UNDO TABLESPACE UndoUber DATAFILE 'UndoUber01.dbf' SIZE 25M;

-- c) BigFile Tablespace con 5GB.
CREATE BIGFILE TABLESPACE BigUber DATAFILE 'BigUber01.dbf' SIZE 5G;

-- d) Configurar el Undo Tablespace para ser usado en system.
ALTER SYSTEM SET undo_tablespace = UndoUber;

-- TERCER PUNTO - CREAR UN USUARIO DBA (JUNTO CON EL ROL DBA) Y ASIGNARLO AL TABLESPACE UBER, ESTE USUARIO TIENE ESPACIO ILIMITADO EN LA BASE DE DATOS (DEBE TENER PERMISO PARA CONECTAR).
CREATE ROLE DBArol; -- NOTA: El ROL DBA es un rol por defecto de la base de datos.
GRANT CONNECT TO DBArol;
CREATE USER DBAuser IDENTIFIED BY dba DEFAULT TABLESPACE Uber QUOTA UNLIMITED ON Uber;
GRANT DBArol TO DBAuser;