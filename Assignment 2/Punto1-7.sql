-->> Taller 2
-- NOTA: Antes de ejecutar este script, ejecutar el de 'NewInserts', que mejora y soluciona problemas del Taller1.

--
---- Punto 1
--

CREATE OR REPLACE VIEW MEDIOS_PAGO_CLIENTES AS
    SELECT usuarios.id AS cliente_id, CONCAT(CONCAT(usuarios.nombre, ' '), usuarios.apellido) AS nombre_cliente,
    metodos_pago.id AS medio_pago_id, metodos_pago.tipo_metodo AS tipo, metodos_pago.detalles AS detalles_medio_pago,
    (CASE WHEN metodos_pago.empresa_id > 0 THEN 'VERDADERO' ELSE 'FALSO' END) as empresarial, empresas.nombre AS nombre_empresa
    FROM metodos_pago INNER JOIN usuarios ON metodos_pago.usuario_id = usuarios.id
    LEFT JOIN empresas ON metodos_pago.empresa_id = empresas.id;
    
--SELECT * FROM MEDIOS_PAGO_CLIENTES;  -- Comentado para evitar spam al momento de la ejecucion en el video

--
---- Punto 2
--

CREATE OR REPLACE VIEW VIAJES_CLIENTES AS
    SELECT facturas.fecha AS fecha_viaje,
    c.nombre AS nombre_conductor,
    vehiculos.placa AS placa_vehiculo,
    u.nombre AS nombre_cliente,
    facturas.valor_total,
    (CASE WHEN viajes.tarifa_dinamica > 0 THEN 'VERDADERO' ELSE 'FALSO' END) as tarifa_dinamica,
    viajes.tipo_servicio,    -- Debido a nuestra estructura de la tabla, UberX o UberBlack esta escrito, literal, en la tabla.    
    lugares.ciudad AS ciudad_viaje
    FROM viajes INNER JOIN facturas ON viajes.id = facturas.viaje_id
    INNER JOIN vehiculos ON viajes.vehiculo_id = vehiculos.id
    INNER JOIN usuarios c ON viajes.conductor_id = c.id
    INNER JOIN usuarios u ON viajes.usuario_id = u.id
    INNER JOIN lugares ON viajes.lugar_id = lugares.id
    ORDER BY fecha_viaje DESC;
    
--SELECT * FROM VIAJES_CLIENTES;  -- Comentado para evitar spam al momento de la ejecucion en el video

--
---- Punto 3
--

EXPLAIN PLAN FOR SELECT * FROM VIAJES_CLIENTES;
    
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

--CREATE UNIQUE INDEX viajes_index ON viajes(id);
--CREATE UNIQUE INDEX facturas_index ON facturas(id);
--CREATE UNIQUE INDEX usuarios_index ON usuarios(id);
--CREATE UNIQUE INDEX vehiculos_index ON vehiculos(id);
--CREATE UNIQUE INDEX lugares_index ON lugares(id);


--
---- Punto 4
--

DELETE FROM lugares; -- Asegurar de que la tabla este limpia para hacer nuestos ALTER.
-- Una vez se ejecute este ALTER, insertar las nuevas ciudades del archivo NewInsertsPunto4 para continuar.
ALTER TABLE lugares 
    ADD valor_kilometro NUMBER(9,2) NOT NULL
    ADD valor_minuto NUMBER(9,2) NOT NULL
    ADD tarifa_base NUMBER(9,2) NOT NULL;
    
-- 
---- Punto 5
--    
    
CREATE OR REPLACE FUNCTION VALOR_DISTANCIA(distancia IN NUMBER, lugar IN VARCHAR) RETURN NUMBER AS
    valor NUMBER(9,2) := 0;
    valor_km NUMBER(9,2) := 0;
BEGIN
    IF distancia > 0 THEN
        SELECT valor_kilometro INTO valor_km FROM lugares WHERE ciudad = lugar;
        dbms_output.put_line('Valor por KM en la ciudad: $'||valor_km);
        dbms_output.put_line('Kilometros recorridos: '||distancia);
        valor := distancia * valor_km;
        RETURN valor;
    ELSE
        dbms_output.put_line('Error: Los Kilometros ingresados son invalidos. Usa valores mayores a 0.');
        RETURN valor;
    END IF;    
    
    EXCEPTION 
       WHEN NO_DATA_FOUND THEN 
          dbms_output.put_line('No se encuentra esta ciudad.'); 
          RETURN 0;
       WHEN OTHERS THEN 
          dbms_output.put_line('Error desconocido.'); 
          RETURN 0;
          
    RETURN valor;
END;

-- Ejecucion del comando para probar.
DECLARE
    distancia NUMBER(7,2) := 20.68;
    ciudad VARCHAR(64) := 'Medellin';
BEGIN 
    dbms_output.put_line('Valor de la carrera: $'||VALOR_DISTANCIA(distancia, ciudad));
END;

--
---- Punto 6
--

CREATE OR REPLACE FUNCTION VALOR_TIEMPO(minutos IN NUMBER, lugar IN VARCHAR) RETURN NUMBER AS
    valor NUMBER(9,2) := 0;
    valor_min NUMBER(9,2) := 0;
BEGIN
    IF minutos > 0 THEN
        SELECT valor_minuto INTO valor_min FROM lugares WHERE ciudad = lugar;
        IF valor_min > 0 THEN
            dbms_output.put_line('Valor por Minuto en la ciudad: $'||valor_min);
            dbms_output.put_line('Minutos de recorrido: '||minutos);
            valor := minutos * valor_min;
            RETURN valor;
        END IF;
    ELSE
        dbms_output.put_line('Error: Los Minutos ingresados son invalidos. Usa valores mayores a 0.');
    END IF;    
    
    EXCEPTION 
       WHEN NO_DATA_FOUND THEN 
          dbms_output.put_line('No se encuentra esta ciudad.'); 
          RETURN 0;
       WHEN OTHERS THEN 
          dbms_output.put_line('Error desconocido.'); 
          RETURN 0;
          
    RETURN valor;
END;

-- Ejecucion del comando para probar.
DECLARE
    minutos NUMBER(7,2) := 28;
    ciudad VARCHAR(64) := 'Medellin';
BEGIN 
    dbms_output.put_line('Valor de la carrera: $'||VALOR_TIEMPO(minutos, ciudad));
END;

--
---- Punto 7
--

CREATE OR REPLACE PROCEDURE CALCULAR_TARIFA (viaje IN NUMBER) AS
    -- Consultando en la base de datos
    distancia NUMBER(9,2);
    tiempo NUMBER(9,2);
    ciudad VARCHAR(64);
    valor_base NUMBER(9,2);
    factura INT;
    estado VARCHAR(32);
    
    -- Internos del procedimiento   
    total NUMBER(9,2) := 0;
    valor_detalles NUMBER := 0;
    valor_calculado_kilometro NUMBER(9,2);
    valor_calculado_minuto NUMBER(9,2);
    
    -- Cursor
    CURSOR detalle_cursor IS SELECT valor FROM factura_detalles WHERE factura_detalles.factura_id = factura;
    detalles_t  detalle_cursor%ROWTYPE;
    TYPE detalles_ntt IS TABLE OF detalles_t%TYPE;
    l_detalles  detalles_ntt;
    
BEGIN
    -- Primer SELECT para obtener detalles basicos del viaje y la factura.
    SELECT viajes.distancia, viajes.tiempo_viaje,    lugares.ciudad, lugares.tarifa_base,   facturas.id, facturas.estado
    INTO distancia, tiempo,     ciudad, valor_base,     factura, estado
    FROM viajes INNER JOIN lugares ON viajes.lugar_id = lugares.id
    INNER JOIN facturas ON facturas.viaje_id = viajes.id
    WHERE viajes.id = viaje;
    dbms_output.put_line('Viaje realizado en la Ciudad de '||ciudad); 
    
    -- Iniciamos a calcular la tarifa.
    valor_calculado_kilometro := VALOR_DISTANCIA(distancia, ciudad);
    valor_calculado_minuto := VALOR_TIEMPO(tiempo, ciudad);
    dbms_output.put_line('Valor por recorrer '||distancia||' Kilometros: $'||valor_calculado_kilometro); 
    dbms_output.put_line('Valor por recorrer '||tiempo||' Minutos: $'||valor_calculado_minuto); 
    
    -- Iniciamos a sumar los valores de los conceptos extra usando nuetro cursor.
    OPEN  detalle_cursor;
    FETCH detalle_cursor BULK COLLECT INTO l_detalles;
    CLOSE detalle_cursor;
    FOR indx IN 1..l_detalles.COUNT LOOP
         -- dbms_output.put_line(l_detalles(indx).valor); -- Mostrar los costos de manera individual
         valor_detalles := valor_detalles + l_detalles(indx).valor;
    END LOOP;
    dbms_output.put_line('Valor por conceptos extra: $'||valor_detalles); 
    
    -- Calculamos el valor total de viaje.
    total := valor_detalles + valor_calculado_kilometro + valor_calculado_minuto + valor_base;
    dbms_output.put_line('TOTAL: $'||total||' para la factura ID '||factura); 
    
    -- Actualizacion final
    IF estado <> 'Pagado' THEN
        -- Parte del punto 7.A que no entiendo
        UPDATE facturas SET facturas.valor_total = '0' WHERE facturas.id = factura;
        dbms_output.put_line('Si el estado del viaje es diferente a REALIZADO, deberá insertar 0 en el valor de la tarifa. ??????'); 
        dbms_output.put_line('Imposible actualizar el valor total. El viaje aun no esta REALIZADO.'); 
    ELSE
        -- Poner el valor final a la factura
        UPDATE facturas SET facturas.valor_total = total WHERE facturas.id = factura;
        dbms_output.put_line('Proceso exitoso.'); 
    END IF;
    
    -- Control de excepciones
    EXCEPTION 
       WHEN NO_DATA_FOUND THEN 
          dbms_output.put_line('No se encuentra este viaje.'); 
          IF factura <> NULL THEN
            UPDATE facturas SET facturas.valor_total = '0' WHERE facturas.id = factura;
          END IF;
       WHEN OTHERS THEN 
          dbms_output.put_line('Error desconocido.'); 
          UPDATE facturas SET facturas.valor_total = '0' WHERE facturas.id = factura;
          IF factura <> NULL THEN
            UPDATE facturas SET facturas.valor_total = '0' WHERE facturas.id = factura;
          END IF;
END;

-- Ejecucion del comando para probar.
DECLARE
    viaje INT := 11;
BEGIN 
    CALCULAR_TARIFA (viaje);
END;

SELECT valor_total FROM facturas WHERE id = 11;
