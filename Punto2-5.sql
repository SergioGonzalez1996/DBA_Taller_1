--
---- SEGUNDO PUNTO - CREAR 3 TABLESPACES
--

-- a) El primer Tablespaces con 2GB y un Datafile, su nombre debe ser Uber.
CREATE TABLESPACE Uber DATAFILE 'Uber01.dbf' SIZE 2G;

-- b) Undo Tablespace con 25MB de espacio y un Datafile.
CREATE UNDO TABLESPACE UndoUber DATAFILE 'UndoUber01.dbf' SIZE 25M;

-- c) BigFile Tablespace con 5GB.
CREATE BIGFILE TABLESPACE BigUber DATAFILE 'BigUber01.dbf' SIZE 5G;

-- d) Configurar el Undo Tablespace para ser usado en system.
ALTER SYSTEM SET undo_tablespace = UndoUber;

--
---- TERCER PUNTO - CREAR UN USUARIO DBA (JUNTO CON EL ROL DBA) Y ASIGNARLO AL TABLESPACE UBER, ESTE USUARIO TIENE ESPACIO ILIMITADO EN LA BASE DE DATOS (DEBE TENER PERMISO PARA CONECTAR).
--

CREATE ROLE DBArol; -- NOTA: El ROL DBA es un rol por defecto de la base de datos.
GRANT CONNECT TO DBArol;
CREATE USER DBAuser 
  IDENTIFIED BY dba 
  DEFAULT TABLESPACE Uber 
  QUOTA UNLIMITED ON Uber;
GRANT DBArol TO DBAuser;

--
---- CUARTO PUNTO - CREAR 4 PERFILES.
--

-- a) Perfil 1: "clerk", vida de la contraseña de 40 días, una sesión por usuario, 10 minutos IDLE, 4 intentos de login.
CREATE PROFILE clerk LIMIT 
  PASSWORD_LIFE_TIME 40 
  SESSIONS_PER_USER 1 
  IDLE_TIME 10 
  FAILED_LOGIN_ATTEMPTS 4;

-- b) Profile 2: "development", vida de la contraseña de 100 días, dos sesiones por usuario, 30 minutos IDLE, sin intentos de login fallidos.
CREATE PROFILE development LIMIT 
  PASSWORD_LIFE_TIME 100 
  SESSIONS_PER_USER 2
  IDLE_TIME 30 
  FAILED_LOGIN_ATTEMPTS 1;
  
--
---- QUINTO PUNTO - CREAR 4 USUARIOS Y ASIGNARLOS AL TABLESPACE UBER.
--

-- a) 2 de ellos deben tener el perfil clerk y los otros el perfil de development. Todos los usuarios deben de tener los permisos de conexión a la base de datos.
CREATE USER sergiogonzalez
  IDENTIFIED BY sergiogonzalez
  DEFAULT TABLESPACE uber
  QUOTA 10M ON uber
  PROFILE development;
  
CREATE USER manuelchaverra
  IDENTIFIED BY manuelchaverra
  DEFAULT TABLESPACE uber
  QUOTA 10M ON uber
  PROFILE development; 
  
CREATE USER juangomez
  IDENTIFIED BY juangomez
  DEFAULT TABLESPACE uber
  QUOTA 10M ON uber
  PROFILE clerk; 
  
CREATE USER amartinez
  IDENTIFIED BY amartinez
  DEFAULT TABLESPACE uber
  QUOTA 10M ON uber
  PROFILE clerk; 

GRANT DBArol TO sergiogonzalez, manuelchaverra, juangomez, amartinez;

-- b) Bloquear un usuario asociado con el perfil de clerk.
ALTER USER amartinez ACCOUNT LOCK;