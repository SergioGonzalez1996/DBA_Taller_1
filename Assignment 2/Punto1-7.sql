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
    
SELECT * FROM MEDIOS_PAGO_CLIENTES;  -- Probar !

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
    
SELECT * FROM VIAJES_CLIENTES;  -- Probar !

--
---- Punto 3
--

-- Obtener el plan de ejecucion actual para la tabla.
EXPLAIN PLAN FOR SELECT * FROM VIAJES_CLIENTES;  
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

-- Debido a que todos los datos de nuestra vista se estan consultando por CLAVE PRIMARIA no podemos crear indices.
-- Es por ello, que usaremos un WHERE cualquiera para la vista y a la columna de ese WHERE pondremos un indice.
-- Posteriormente, haremos un nuevo plan de ejecucion para la vista, con el WHERE nuevo.
-- Se podra consultar los resultados en las imagenes Punto3_ExplainPlan_... de la carpeta Assignment 2.

-- TO DO


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
    NO_VALID_DISTANCE EXCEPTION;
BEGIN
    IF distancia <= 0 THEN
        RAISE NO_VALID_DISTANCE;
    END IF;

    SELECT valor_kilometro INTO valor_km FROM lugares WHERE ciudad = lugar;
    dbms_output.put_line('Valor por KM en la ciudad: $'||valor_km);
    dbms_output.put_line('Kilometros recorridos: '||distancia);
    valor := distancia * valor_km;
    RETURN valor;
    
    EXCEPTION 
        WHEN NO_VALID_DISTANCE THEN
            dbms_output.put_line('Error: Los Kilometros ingresados son invalidos. Usa valores mayores a 0.');
            RETURN 0;
        WHEN NO_DATA_FOUND THEN 
            dbms_output.put_line('Error: No se encuentra esta ciudad.'); 
            RETURN 0;
        WHEN TOO_MANY_ROWS THEN
            dbms_output.put_line('Error: La consulta arrojo demasiadas valores. Se esperaba solo 1.'); 
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
    dbms_output.put_line('Valor de la carrera por su distancia: $'||VALOR_DISTANCIA(distancia, ciudad));
END;

--
---- Punto 6
--

CREATE OR REPLACE FUNCTION VALOR_TIEMPO(minutos IN NUMBER, lugar IN VARCHAR) RETURN NUMBER AS
    valor NUMBER(9,2) := 0;
    valor_min NUMBER(9,2) := 0;
    NO_VALID_MINUTES EXCEPTION;
BEGIN
    IF minutos <= 0 THEN
        RAISE NO_VALID_MINUTES;
    END IF;
    
    SELECT valor_minuto INTO valor_min FROM lugares WHERE ciudad = lugar;
    dbms_output.put_line('Valor por Minuto en la ciudad: $'||valor_min);
    dbms_output.put_line('Minutos de recorrido: '||minutos);
    valor := minutos * valor_min;
    RETURN valor;   
    
    EXCEPTION           
        WHEN NO_VALID_MINUTES THEN
            dbms_output.put_line('Error: Los Minutos ingresados son invalidos. Usa valores mayores a 0.');
            RETURN 0;
        WHEN NO_DATA_FOUND THEN 
            dbms_output.put_line('Error: No se encuentra esta ciudad.'); 
            RETURN 0;
        WHEN TOO_MANY_ROWS THEN
            dbms_output.put_line('Error: La consulta arrojo demasiadas valores. Se esperaba solo 1.'); 
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
    dbms_output.put_line('Valor de la carrera por su duracion: $'||VALOR_TIEMPO(minutos, ciudad));
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
    factura INT := 0;
    estado VARCHAR(32);
    
    -- Internos del procedimiento   
    total NUMBER(9,2) := 0;
    valor_detalles NUMBER := 0;
    valor_calculado_kilometro NUMBER(9,2);
    valor_calculado_minuto NUMBER(9,2);
    
    -- Cursor.
    ---- NOTA: Es diferente por que este trae todas las columnas. Fue consultado en la documentacion.
    CURSOR detalle_cursor IS SELECT valor,concepto FROM factura_detalles WHERE factura_detalles.factura_id = factura;
    detalles_t  detalle_cursor%ROWTYPE;
    TYPE detalles_ntt IS TABLE OF detalles_t%TYPE;
    l_detalles  detalles_ntt;
    
BEGIN
    -- Primer SELECT para obtener detalles basicos del viaje y la ID de la factura.
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
    dbms_output.put_line('Conceptos y Costos extra del viaje:'); 
    FOR indx IN 1..l_detalles.COUNT LOOP
         dbms_output.put_line(l_detalles(indx).concepto||': $'||l_detalles(indx).valor); -- Mostrar los costos de manera individual
         valor_detalles := valor_detalles + l_detalles(indx).valor;
    END LOOP;
    dbms_output.put_line('Valor total por conceptos extra: $'||valor_detalles); 
    
    -- Calculamos el valor total de viaje.
    total := valor_detalles + valor_calculado_kilometro + valor_calculado_minuto + valor_base;
    dbms_output.put_line('TOTAL: $'||total||' para la factura ID '||factura); 
    
    -- Actualizacion final
    -- Nota sobre el estado: La tabla factura tiene el CONSTRAINT 'check_estado' que solo permite los siguientes valores:
    -- 'Realizado', 'Cancelado', 'En marcha'
    IF estado <> 'Realizado' THEN
        UPDATE facturas SET facturas.valor_total = '0' WHERE facturas.id = factura;
        dbms_output.put_line('Imposible actualizar el valor total. El viaje aun no esta REALIZADO. Estado actual: '||estado); 
    ELSE
        -- Poner el valor final a la factura
        UPDATE facturas SET facturas.valor_total = total WHERE facturas.id = factura;
        dbms_output.put_line('Proceso exitoso.'); 
    END IF;
    
    -- Control de excepciones
    EXCEPTION 
       WHEN NO_DATA_FOUND THEN 
          dbms_output.put_line('No se encuentra este viaje.'); 
          IF factura > 0 THEN -- -- Verificar que si haya encontrado la ID de la factura
            UPDATE facturas SET facturas.valor_total = '0' WHERE facturas.id = factura;
          END IF;
       WHEN OTHERS THEN 
          dbms_output.put_line('Error desconocido.'); 
          IF factura > 0 THEN -- Verificar que si haya encontrado la ID de la factura
            UPDATE facturas SET facturas.valor_total = '0' WHERE facturas.id = factura;
          END IF;
END;

-- Ejecucion del comando para probar.
DECLARE
    viaje INT := 11;
BEGIN 
    CALCULAR_TARIFA (viaje);
END;

-- Verificar que el valor si se haya actualizado
SELECT valor_total FROM facturas WHERE id = 1;
