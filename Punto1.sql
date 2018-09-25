-- Primera version, sin los constraint.

CREATE TABLE "usuarios" (
  "id" INT,
  "nombre" VARCHAR(32),
  "apellido" VARCHAR(32),
  "pais" VARCHAR(32),
  "celular" VARCHAR(16),
  "idioma" VARCHAR(16),
  "codigo_invitacion" VARCHAR(255),
  "foto_perfil" VARCHAR(255),
  "recibos_email_id" INT,
  "tipo_usuario" VARCHAR(16),
  PRIMARY KEY ("id")
);

CREATE TABLE "emails" (
  "id" INT,
  "usuario_id" INT,
  "email" VARCHAR(64),
  PRIMARY KEY ("id")
);

--CREATE INDEX "FK" ON  "emails" ("usuario_id");

CREATE TABLE "metodos_pago" (
  "id" INT,
  "usuario_id" INT,
  "tipo_metodo" VARCHAR(8),
  "detalles" VARCHAR(255),
  PRIMARY KEY ("id")
);

--CREATE INDEX "FK" ON  "metodos_pago" ("usuario_id");

CREATE TABLE "viajes" (
  "id" INT,
  "usuario_id" INT,
  "metodo_pago_id" INT,
  "conductor_id" INT,
  "fecha" DATE,
  "tarifa_dinamica" CHAR,
  "divisa" VARCHAR(4),
  "costo" NUMBER(10,2),
  "carro" VARCHAR(8),
  "ciudad" VARCAHR(32),
  PRIMARY KEY ("id")
);

--CREATE INDEX "FK" ON  "viajes" ("usuario_id", "metodo_pago_id", "conductor_id");

CREATE TABLE "viaje_detalles" (
  "id" INT,
  "viaje_id" INT,
  "hora_inicio" DATE,
  "origen" VARCHAR(255),
  "hora_final" DATE,
  "destino" VARCHAR(255),
  "distancia" NUMBER(5,3),
  "tiempo_viaje" VARCHAR(16),
  "peajes" NUMBER(10,2),
  "impuestos" NUMBER(10,2),
  "propina" NUMBER(10,2),
  "id_usuario_compartido" INT,
  "id_empresa" INT,
  PRIMARY KEY ("id")
);

--CREATE INDEX "FK" ON  "viaje_detalles" ("viaje_id");

CREATE TABLE "empresas" (
  "id" INT,
  "nombre" VARCHAR(64),
  "razon_social" INT,
  PRIMARY KEY ("id")
);

CREATE TABLE "usuario_empresa" (
  "id" INT,
  "usuario_id" INT,
  "empresa" INT,
  PRIMARY KEY ("id")
);

--CREATE INDEX "FK" ON  "usuario_empresa" ("usuario_id", "empresa");

CREATE TABLE "viaje_recorrido" (
  "id" INT,
  "viaje_id" INT,
  "latitud" FLOAT,
  "longitud" FLOAT,
  PRIMARY KEY ("id")
);

--CREATE INDEX "FK" ON  "viaje_recorrido" ("viaje_id");

CREATE TABLE "vehiculos" (
  "id" INT,
  "usuario_id" INT,
  "placa" VARCHAR(16),
  "marca" VARCHAR(16),
  "modelo" VARCHAR(32),
  "year" VARCHAR(32),
  PRIMARY KEY ("id")
);

--CREATE INDEX "FK" ON  "vehiculos" ("usuario_id");

CREATE TABLE "metodos_pago_conductores" (
  "id" INT,
  "usuario_id" INT,
  "entidad" VARCHAR(32),
  "cuenta" VARCHAR(32),
  PRIMARY KEY ("id")
);

--CREATE INDEX "FK" ON  "metodos_pago_conductores" ("usuario_id");

CREATE TABLE "detalle_pago_conductores" (
  "id" INT,
  "usuario_id" INT,
  "fecha" DATE,
  "servicios_prestados" INT,
  "pago" NUMBER(10,2),
  "costo_comision" NUMBER(10,2),
  PRIMARY KEY ("id")
);

--CREATE INDEX "FK" ON  "detalle_pago_conductores" ("usuario_id");


-- Insertar valores bool

--create table tbool (
--    bool char check (bool in (0,1))
--);
--insert into tbool values(0);
--insert into tbool values(1);
