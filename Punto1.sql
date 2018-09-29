--
---- Creacion de todas las tablas y constraints
--

CREATE TABLE usuarios (
  id INT,
  nombre VARCHAR(32) NOT NULL,
  apellido VARCHAR(32) NOT NULL,
  celular VARCHAR(32) NOT NULL,
  idioma VARCHAR(32) NOT NULL,
  codigo_invitacion VARCHAR(16) NOT NULL,
  foto_perfil VARCHAR(1024) NOT NULL,
  tipo_usuario VARCHAR(16) NOT NULL,
  
  lugar_id INT NOT NULL,
  metodos_pago_id INT,                          -- Si el valor es nulo, envia a todos, si no, enviará sólo a el metodo asociado con esa ID.
  
  CONSTRAINT usuarios_pk PRIMARY KEY (id)
);

CREATE TABLE codigos_promocionales (
    id INT,
    codigo VARCHAR(16) NOT NULL,
    estado VARCHAR(16) NOT NULL,        -- Posibles estados: disponible/usado/cerrado
    valor_bono NUMBER(9,2) NOT NULL,
    valor_disponible NUMBER(9,2) NOT NULL,
    
    usuario_id INT NOT NULL,
    
    CONSTRAINT codigos_promocionales_id PRIMARY KEY (id)
);

CREATE TABLE emails (
  id INT,
  email VARCHAR(64) NOT NULL,
     
  usuario_id INT NOT NULL,
  
  CONSTRAINT emails_pk PRIMARY KEY (id)
);

CREATE TABLE lugares (
    id INT,
    pais VARCHAR(64) NOT NULL,
    ciudad VARCHAR(64) NOT NULL,
    divisa VARCHAR(4) NOT NULL, -- Codigo de divisas: EJ: COP, USD, EUR, etc.
    
    -- unir con usuarios y con viajes
    CONSTRAINT lugares_pk PRIMARY KEY (id)
);


CREATE TABLE metodos_pago (
  id INT,
  tipo_metodo VARCHAR(8) NOT NULL,
  detalles VARCHAR(255),
  
  usuario_id INT NOT NULL,
  
  CONSTRAINT metodos_pago_pk PRIMARY KEY (id)
);


CREATE TABLE viajes (
  id INT,
  fecha DATE NOT NULL,
  tarifa_dinamica CHAR NOT NULL CHECK (bool in (0,1)),
  
  hora_inicio DATE NOT NULL,
  origen VARCHAR(512) NOT NULL,
  hora_final DATE NOT NULL,
  destino VARCHAR(512) NOT NULL,
  distancia NUMBER(5,3) NOT NULL,
  tiempo_viaje VARCHAR(16) NOT NULL,    -- HH:MM:SS -- 00:08:50
  tipo_servicio VARCHAR(16) NOT NULL,   -- UberX o Black ?
  
  usuario_id INT NOT NULL,
  conductor_id INT NOT NULL,
  vehiculo_id INT NOT NULL,
  lugar_id INT NOT NULL,
  
  CONSTRAINT viajes_pk PRIMARY KEY (id)
);



CREATE TABLE facturas (
  id INT,
  estado VARCHAR(32) NOT NULL,        -- Esta pagada? en marcha? finalizada? cancelada?
  fecha DATE NOT NULL,
  valor_total NUMBER(9,2) NOT NULL,

  viaje_id INT NOT NULL,
  metodo_pago_id INT NOT NULL,
  codigo_promocional_id INT,
  usuario_compartido_id INT,
  empresa_id INT,
  
  CONSTRAINT facturas_pk PRIMARY KEY (id)
);

CREATE TABLE factura_detalles (
 id INT,
 concepto VARCHAR(32) NOT NULL,     -- Tipo, peajes, impuestos, propina, etc...
 valor NUMBER(9,2) NOT NULL, 
 
 factura_id INT NOT NULL,
 
 CONSTRAINT factura_detalles_pk PRIMARY KEY (id)
);


CREATE TABLE empresas (
  id INT,
  nombre VARCHAR(64) NOT NULL,
  razon_social INT NOT NULL,
  
  CONSTRAINT empresas_pk PRIMARY KEY (id)
);

CREATE TABLE usuario_empresa (
  id INT NOT NULL,
  usuario_id INT NOT NULL,
  empresa_id INT NOT NULL,
  
  CONSTRAINT usuario_empresa_pk PRIMARY KEY (id)
);


CREATE TABLE viaje_recorrido (
  id INT,
  latitud FLOAT NOT NULL,
  longitud FLOAT NOT NULL,
  
  viaje_id INT NOT NULL,
  
  CONSTRAINT viaje_recorrido_pk PRIMARY KEY (id)
);



CREATE TABLE vehiculos (
  id INT,
  placa VARCHAR(16) NOT NULL,
  marca VARCHAR(16) NOT NULL,
  modelo VARCHAR(32) NOT NULL,
  year VARCHAR(32) NOT NULL, -- No poner año para no dañar la integridad de la base de datos
  
  CONSTRAINT vehiculos_id PRIMARY KEY (id)
);

CREATE TABLE usuario_vehiculo (
 id INT,    
 usuario_id INT NOT NULL,
 vehiculo_id INT NOT NULL,

 CONSTRAINT usuario_vehiculo_id PRIMARY KEY (id)
);


CREATE TABLE metodos_pago_conductores (
  id INT,
  banco VARCHAR(64) NOT NULL,
  tipo_cuenta VARCHAR(16) NOT NULL,
  cuenta VARCHAR(64) NOT NULL,
  
  usuario_id INT NOT NULL,
  
  CONSTRAINT metodos_pago_conductores_id PRIMARY KEY (id)
);



CREATE TABLE detalle_pago_conductores (
  id INT,
  fecha DATE NOT NULL,
  cantidad_servicios INT NOT NULL,
  pago_bruto NUMBER(10,2) NOT NULL,
  costo_comision NUMBER(10,2) NOT NULL,
  pago_neto NUMBER(10,2) NOT NULL,
  
  usuario_id INT NOT NULL,
  metodos_pago_conductores_id INT NOT NULL,

  CONSTRAINT detalle_pago_conductores_pk PRIMARY KEY (id)
);