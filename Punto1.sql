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

CREATE SEQUENCE usuarios_id_seq;

CREATE TABLE codigos_promocionales (
    id INT,
    codigo VARCHAR(16) NOT NULL,
    estado VARCHAR(16) NOT NULL,        -- Posibles estados: disponible/usado/cerrado
    valor_bono NUMBER(9,2) NOT NULL,
    valor_disponible NUMBER(9,2) NOT NULL,
    
    usuario_id INT NOT NULL,
    
    CONSTRAINT codigos_promocionales_id PRIMARY KEY (id)
);

CREATE SEQUENCE cod_prom_id_seq;

CREATE TABLE emails (
  id INT,
  email VARCHAR(64) NOT NULL,
     
  usuario_id INT NOT NULL,
  
  CONSTRAINT emails_pk PRIMARY KEY (id)
);

CREATE SEQUENCE emails_id_seq;

CREATE TABLE lugares (
    id INT,
    pais VARCHAR(64) NOT NULL,
    ciudad VARCHAR(64) NOT NULL,
    divisa VARCHAR(4) NOT NULL, -- Codigo de divisas: EJ: COP, USD, EUR, etc.
    
    -- unir con usuarios y con viajes
    CONSTRAINT lugares_pk PRIMARY KEY (id)
);

CREATE SEQUENCE lugares_id_seq;

CREATE TABLE metodos_pago (
  id INT,
  tipo_metodo VARCHAR(8) NOT NULL,
  detalles VARCHAR(255),
  
  usuario_id INT NOT NULL,
  
  CONSTRAINT metodos_pago_pk PRIMARY KEY (id)
);

CREATE SEQUENCE metodos_pago_id_seq;

CREATE TABLE viajes (
  id INT,
  fecha DATE NOT NULL,
  tarifa_dinamica CHAR NOT NULL, 
  
  hora_inicio DATE NOT NULL,
  origen VARCHAR(512) NOT NULL,
  hora_final DATE NOT NULL,
  destino VARCHAR(512) NOT NULL,
  distancia NUMBER(5,3) NOT NULL,
  tiempo_viaje NUMBER(9,2) NOT NULL,    -- Minutos
  tipo_servicio VARCHAR(16) NOT NULL,   -- UberX o Black ?
  
  usuario_id INT NOT NULL,
  conductor_id INT NOT NULL,
  vehiculo_id INT NOT NULL,
  lugar_id INT NOT NULL,
  
  CONSTRAINT viajes_pk PRIMARY KEY (id),
  CONSTRAINT chk_tarifa CHECK (tarifa_dinamica = 0 OR tarifa_dinamica = 1)
);

CREATE SEQUENCE viajes_id_seq;

CREATE TABLE viaje_recorrido (
  id INT,
  latitud FLOAT NOT NULL,
  longitud FLOAT NOT NULL,
  
  viaje_id INT NOT NULL,
  
  CONSTRAINT viaje_recorrido_pk PRIMARY KEY (id)
);

CREATE SEQUENCE viaje_recor_id_seq;

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

CREATE SEQUENCE facturas_id_seq;

CREATE TABLE factura_detalles (
 id INT,
 concepto VARCHAR(32) NOT NULL,     -- Tipo, peajes, impuestos, propina, etc...
 valor NUMBER(9,2) NOT NULL, 
 
 factura_id INT NOT NULL,
 
 CONSTRAINT factura_detalles_pk PRIMARY KEY (id)
);

CREATE SEQUENCE factu_deta_id_seq;

CREATE TABLE empresas (
  id INT,
  nombre VARCHAR(64) NOT NULL,
  razon_social INT NOT NULL,
  
  CONSTRAINT empresas_pk PRIMARY KEY (id)
);

CREATE SEQUENCE empresas_id_seq;

CREATE TABLE usuario_empresa (
  id INT NOT NULL,
  usuario_id INT NOT NULL,
  empresa_id INT NOT NULL,
  
  CONSTRAINT usuario_empresa_pk PRIMARY KEY (id)
);

CREATE SEQUENCE usu_empr_id_seq;

CREATE TABLE vehiculos (
  id INT,
  placa VARCHAR(16) NOT NULL,
  marca VARCHAR(16) NOT NULL,
  modelo VARCHAR(32) NOT NULL,
  year VARCHAR(32) NOT NULL, -- No poner año para no dañar la integridad de la base de datos
  
  CONSTRAINT vehiculos_id PRIMARY KEY (id)
);

CREATE SEQUENCE vehiculos_id_seq;

CREATE TABLE usuario_vehiculo (
 id INT,    
 usuario_id INT NOT NULL,
 vehiculo_id INT NOT NULL,

 CONSTRAINT usuario_vehiculo_id PRIMARY KEY (id)
);

CREATE SEQUENCE usu_veh_id_seq;

CREATE TABLE metodos_pago_conductores (
  id INT,
  banco VARCHAR(64) NOT NULL,
  tipo_cuenta VARCHAR(16) NOT NULL,
  cuenta VARCHAR(64) NOT NULL,
  
  usuario_id INT NOT NULL,
  
  CONSTRAINT metodos_pago_conductores_id PRIMARY KEY (id)
);

CREATE SEQUENCE meto_pag_conduc_id_seq;

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

CREATE SEQUENCE det_pago_conduc_id_seq;

--
---- Claves Foraneas
--

ALTER TABLE usuarios ADD CONSTRAINT fk_lugar_usuarios_id FOREIGN KEY (lugar_id) REFERENCES lugares(id);
ALTER TABLE usuarios ADD CONSTRAINT fk_metodos_pago_usuarios_id FOREIGN KEY (metodos_pago_id) REFERENCES metodos_pago(id);

ALTER TABLE codigos_promocionales ADD CONSTRAINT fk_usr_cod_promo_id FOREIGN KEY (usuario_id) REFERENCES usuarios(id);

ALTER TABLE emails ADD CONSTRAINT fk_usuario_emails_id FOREIGN KEY (usuario_id) REFERENCES usuarios(id);

ALTER TABLE metodos_pago ADD CONSTRAINT fk_usuario_metodos_pago_id FOREIGN KEY (usuario_id) REFERENCES usuarios(id);

ALTER TABLE viajes ADD CONSTRAINT fk_usuario_viajes_id FOREIGN KEY (usuario_id) REFERENCES usuarios(id);
ALTER TABLE viajes ADD CONSTRAINT fk_conductor_viajes_id FOREIGN KEY (conductor_id) REFERENCES usuarios(id);
ALTER TABLE viajes ADD CONSTRAINT fk_vehiculo_viajes_id FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id);
ALTER TABLE viajes ADD CONSTRAINT fk_lugar_viajes_id FOREIGN KEY (lugar_id) REFERENCES lugares(id);

ALTER TABLE facturas ADD CONSTRAINT fk_viaje_facturas_id FOREIGN KEY (viaje_id) REFERENCES viajes(id);
ALTER TABLE facturas ADD CONSTRAINT fk_metodo_pago_facturas_id FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id);
ALTER TABLE facturas ADD CONSTRAINT fk_cod_promo_facturas_id FOREIGN KEY (codigo_promocional_id) REFERENCES codigos_promocionales(id);
ALTER TABLE facturas ADD CONSTRAINT fk_usuario_compartido_id FOREIGN KEY (usuario_compartido_id) REFERENCES usuarios(id);
ALTER TABLE facturas ADD CONSTRAINT fk_empresa_facturas_id FOREIGN KEY (empresa_id) REFERENCES empresas(id);

ALTER TABLE factura_detalles ADD CONSTRAINT fk_factura_factura_detalles_id FOREIGN KEY (factura_id) REFERENCES facturas(id);

ALTER TABLE usuario_empresa ADD CONSTRAINT fk_usuario_empresa_id FOREIGN KEY (usuario_id) REFERENCES usuarios(id);
ALTER TABLE usuario_empresa ADD CONSTRAINT fk_empresa_usuario_id FOREIGN KEY (empresa_id) REFERENCES empresas(id);

ALTER TABLE viaje_recorrido ADD CONSTRAINT fk_viaje_recorrido_viaje_id FOREIGN KEY (viaje_id) REFERENCES viajes(id);

ALTER TABLE usuario_vehiculo ADD CONSTRAINT fk_usuario_vehiculo_id FOREIGN KEY (usuario_id) REFERENCES usuarios(id);
ALTER TABLE usuario_vehiculo ADD CONSTRAINT fk_vehiculo_usuario_id FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id);

ALTER TABLE metodos_pago_conductores ADD CONSTRAINT fk_usr_metodos_pago_id FOREIGN KEY (usuario_id) REFERENCES usuarios(id);

ALTER TABLE detalle_pago_conductores ADD CONSTRAINT fk_usuario_detalle_pago_id FOREIGN KEY (usuario_id) REFERENCES usuarios(id);
ALTER TABLE detalle_pago_conductores ADD CONSTRAINT fk_metodos_pago_conductores_id FOREIGN KEY (metodos_pago_conductores_id) REFERENCES metodos_pago_conductores(id);