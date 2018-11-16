--> New Alter Tables
-- Aqui pondremos comandos para solucionar problemas o mejorar la base de datos propuesta en el Taller 1.

-- Primero realizamos una pequeña edicion a nuestras otras tablas para hacer posible la consulta del Punto1.
ALTER TABLE metodos_pago ADD empresa_id INT NULL;
ALTER TABLE metodos_pago ADD CONSTRAINT fk_metodos_pago_empresa_id FOREIGN KEY (empresa_id) REFERENCES empresas(id);

-->> New Inserts and data to test

INSERT INTO empresas (id, nombre, razon_social) values (empresas_id_seq.NEXTVAL, 'SX', '11527027022'); 

UPDATE metodos_pago SET empresa_id = '1' WHERE id = '1';
UPDATE metodos_pago SET empresa_id = '1' WHERE id = '3';
UPDATE metodos_pago SET empresa_id = '1' WHERE id = '5';

-->> New Viajes for testing purpuses

-- SELECT * FROM lugares WHERE ciudad = 'Medellin'; -- La ID de Medellin es 600
 
INSERT INTO viajes 
    (id, fecha, tarifa_dinamica, hora_inicio, origen, hora_final, destino, distancia, tiempo_viaje, tipo_servicio, usuario_id, conductor_id, vehiculo_id, lugar_id) 
    VALUES (viajes_id_seq.NEXTVAL, '14/11/2018', 0, '09/10/2017', '838 Luster Crossing', '07/10/2018', '459 Kenwood Trail', 20.68, 28, 'Black', 1, 5, 11, 600);

INSERT INTO viajes 
    (id, fecha, tarifa_dinamica, hora_inicio, origen, hora_final, destino, distancia, tiempo_viaje, tipo_servicio, usuario_id, conductor_id, vehiculo_id, lugar_id) 
    VALUES (viajes_id_seq.NEXTVAL, '14/11/2018', 1, '09/10/2017', '838 Luster Crossing', '07/10/2018', '459 Kenwood Trail', 50, 30, 'UberX', 2, 10, 22, 600);
    
    
--SELECT * FROM viajes WHERE lugar_id = 600; -- Las IDs insertadas anteriormente son 11 y 12

INSERT INTO facturas 
   (id, estado, fecha, valor_total, viaje_id, metodo_pago_id, codigo_promocional_id, usuario_compartido_id, empresa_id) 
    VALUES (facturas_id_seq.NEXTVAL, 'Realizado', '14/11/2018', 0, 11, 587, null, null, null);
    

INSERT INTO facturas 
   (id, estado, fecha, valor_total, viaje_id, metodo_pago_id, codigo_promocional_id, usuario_compartido_id, empresa_id) 
    VALUES (facturas_id_seq.NEXTVAL, 'Realizado', '14/11/2018', 0, 12, 587, null, null, null);
    