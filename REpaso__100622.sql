 /* Sacar código */
 
 DBMS_OUTPUT.PUT_LINE('El empleado ' || v_id_emp || ' ' || v_nombre_emp || ' posee un salario de $' || v_salario_emp);

 -- Declarar Variables

DECLARE
v_id_emp NUMBER(4);
v_nombre_emp VARCHAR2(30);
BEGIN

-- Otra forma
DECLARE
  v_Minombre VARCHAR2(20):= 'Juan';
BEGIN
  v_Minombre:= 'Roberto';

  -- mas ejemplo>
    v_trabajo_emp      VARCHAR2(9);
  v_cont_loop          BINARY_INTEGER := 0;
  v_dept_total_sal   NUMBER(9,2) := 0;
  v_fecha_orden      DATE := SYSDATE + 7;
  c_porc_impto        CONSTANT NUMBER(3,2) := 8.25;
  v_valido	               BOOLEAN NOT NULL := TRUE;

-- ejemplo variable bind antes de declare>


VARIABLE b_porcentaje NUMBER
VARIABLE b_resultado NUMBER
EXEC :b_porcentaje:=0.25;
DECLARE
-- tambien se puede usar con el dbsm output 
  DBMS_OUTPUT.PUT_LINE('El valor de la variable b_resultado es ' || :b_resultado);
END;

-- otros ejemplos 
-- declarar valores en 0, usar between 

DECLARE
v_loop_cuenta  NUMBER(3):=0;
v_buen_sal     BOOLEAN;
v_mensaje      VARCHAR2(40);
v_salario      NUMBER(8):=8000;
BEGIN
  v_loop_cuenta  :=  v_loop_cuenta + 1;
  v_buen_sal := v_salario BETWEEN 50000 AND 150000;
  v_mensaje := 'El nuevo salario es: ' || v_salario * 1.15;
END;

-- ejemplos de bloques anidados y exeption

DECLARE
v_nom_emp   employees.first_name%type;
v_nom_pais VARCHAR2(30);
BEGIN
    SELECT first_name INTO v_nom_emp
       FROM employees
     WHERE employee_id = 100;
            BEGIN
                    SELECT country_name INTO v_nom_pais
                        FROM countries
                     WHERE country_id='ZZ';
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No hay fila en tabla COUNTRIES');
            END;
EXCEPTION
WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE('No hay fila en tabla EMPLOYEES');
END;

-- visiidad de una variable

<<bloque_padre>>
DECLARE
 v_nom_padre       VARCHAR2(20):='Patricio';
 v_fecha_cumple  DATE:='20-Abr-1972';
BEGIN

-- llamar esa variable
 DBMS_OUTPUT.PUT_LINE('Don ' || v_nom_padre || ' nació el ' ||bloque_padre.v_fecha_cumple);

-- insertar con pl sql

BEGIN
    INSERT INTO empleados (employee_id, first_name, last_name, email, hire_date, job_id, salary)
     VALUES(EMPLOYEES_SEQ.NEXTVAL, 'Ruth', 'Cores','RCORES', sysdate, 'AD_ASST', 4000);
COMMIT;
END;


BEGIN
    INSERT INTO bono
    (SELECT employee_id, ROUND(salary * 0.20)
        FROM empleados);
COMMIT;
END;


-- Update

DECLARE					
  v_sal_incrementado   EMPLEADOS.salary%TYPE := 800; -- Esta variable se declara salary.%type para que tome el tipo de dato de la tabla 
BEGIN
  UPDATE empleados
         SET salary = salary + v_sal_incrementado
   WHERE job_id = 'ST_CLERK';
COMMIT;
END;

/* 

El savepoint hace es el putno donde se puede retornar luego de un rollback

*/

-- El cursos se usa para manejar un conjunto de resultados de una consulta select


/*

El atributo SQL%NOTFOUND es contrario a SQL%FOUND. Este atributo puede ser utilizado como la condición de salida en un LOOP. Es útil en UPDATE y DELETE cuando no se modifica ninguna fila porque en estos casos no se retornan excepciones.

Se pueden utilizar los atributos SQL%ROWCOUNT, SQL%FOUND, and SQL%NOTFOUND en la sección ejecutable de un bloque después que se ha ejecutado las sentencia DML. PL/SQL no devuelve un error si una sentencia DML no afecta a las filas de la tabla. Sin embargo, si una sentencia SELECT no recupera ninguna fila no se puede controlar usando el atributo SQL%ROWCOUNT ya que PL/SQL devuelve una excepción. 


*/
SQL%FOUND -- contiene un valor booleano que indica TRUE si la última de la sentencia sql ejecutada retorna al menos una fila
SQL%ROWCOUNT -- contiene un valor entero que indica el número de filas que la última sentencia sql afectó
SQL%NOTFOUND -- contiene un valor booleano que indica TRUE si la última de la sentencia sql ejecutada no retorna ninguna fila

-- Ejemplo de sql%

DECLARE
  v_filas_elim    VARCHAR2(30);-- se declara
  v_empno         empleados.employee_id%TYPE := 176;
BEGIN
    DELETE FROM  empleados 
    WHERE employee_id = v_empno;
    v_filas_elim := (SQL%ROWCOUNT || ' fila(s) eliminada(s).'); -- se rellena el valor de la variable
    DBMS_OUTPUT.PUT_LINE (v_filas_elim);
COMMIT;
END;


-- otro ejemplo 


BEGIN
    UPDATE empleados
    SET salary = salary + (salary * NVL(commission_pct,0))
    WHERE salary < 1000;
    IF SQL%FOUND THEN
       DBMS_OUTPUT.PUT_LINE ('Se actualizaron ' || SQL%ROWCOUNT || ' filas');
    ELSE
       DBMS_OUTPUT.PUT_LINE('No se actualizaron filas');
    END IF;
    DELETE FROM empleados
        WHERE salary < 5000;
    IF SQL%NOTFOUND THEN
       DBMS_OUTPUT.PUT_LINE('No se eliminaron filas');
    ELSE
       DBMS_OUTPUT.PUT_LINE ('Se eliminaron ' || SQL%ROWCOUNT || ' filas');
    END IF;
COMMIT;
END;


-- Condiciones


VAR b_id_emp NUMBER
EXEC :b_id_emp:=150
DECLARE 
v_salario NUMBER(8);
BEGIN
  SELECT salary
    INTO v_salario
    FROM empleados
    WHERE employee_id=:b_id_emp;
    IF v_salario < 5000 THEN
       UPDATE empleados
         SET salary=salary*1.30
       WHERE employee_id=:b_id_emp;
    END IF;
COMMIT;
END;


-- Otro Ejemplo de condiciones
VAR b_id_emp NUMBER
EXEC :b_id_emp:=100
DECLARE 
v_salario NUMBER(8);
BEGIN
  SELECT salary
    INTO v_salario
    FROM employees
    WHERE employee_id=:b_id_emp;
    IF v_salario < 5000 THEN
       UPDATE empleados
         SET salary=salary*1.40
        WHERE employee_id=:b_id_emp;
    ELSIF v_salario BETWEEN 5000 AND 18000 THEN
        UPDATE empleados
         SET salary=salary*1.20
       WHERE employee_id=:b_id_emp;
END IF;
COMMIT;
END;

-- Otras condiciones>

LOOP                      
    sentenciaN;
EXIT [WHEN condición];
END LOOP;

-- ejemplo de loop

    DECLARE 
   v_x number := 10; 
BEGIN 
   LOOP 
      dbms_output.put_line(v_x); 
      v_x := v_x + 10; 
      EXIT WHEN v_x > 50; 
   END LOOP; 
   -- Después de la salida del LOOP, la ejecución del bloque PL/SQL continúa aquí
   DBMS_OUTPUT.PUT_LINE('Después del EXIT, el valor de v_x es: ' || v_x); 
END;

--otro ejemplo 

DECLARE
  v_countryid    locations.country_id%TYPE := 'CA';
  v_loc_id          locations.location_id%TYPE;
  v_contador     NUMBER(2) := 1;
  v_new_city     locations.city%TYPE := 'Montreal';
BEGIN
    SELECT MAX(location_id) 
         INTO v_loc_id 
       FROM locations
    WHERE country_id = v_countryid;
    LOOP
        INSERT INTO ubicaciones(location_id, city, country_id)   
        VALUES((v_loc_id + v_contador), v_new_city, v_countryid);
        v_contador := v_contador + 1;
        EXIT WHEN v_contador > 3; -- el loop termina cuando contador es mayor que 3
    END LOOP;
END;

--Loop while 
/*
Permite que  las sentencias se repiten mientras la  condición del loop sea verdadera (TRUE)
*/
WHILE condición LOOP
    sentenciaN;
END LOOP;

--  Ejemplo  While

VAR b_porc_aumento NUMBER
EXEC :b_porc_aumento:=1.25
DECLARE
v_sal_prom NUMBER(7);
v_id_min NUMBER(3);
v_id_max NUMBER(3);
v_tot_emp_act NUMBER(3):=0;
BEGIN
  SELECT ROUND(AVG(salary)),MIN(employee_id), MAX(employee_id)
    INTO v_sal_prom,v_id_min,v_id_max
    FROM employees;    
   WHILE v_id_max > v_id_min LOOP
       UPDATE empleados
          SET salary=ROUND(salary*:b_porc_aumento)
        WHERE employee_id=v_id_min
          AND salary < v_sal_prom;
        IF SQL%ROWCOUNT > 0 THEN
           v_tot_emp_act:=v_tot_emp_act+1;
        END IF;
        v_id_min:=v_id_min+1;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Total de empleados actualizados: ' || v_tot_emp_act);
ROLLBACK;
END;

-- FOR LOOP

DECLARE
  v_countryid   locations.country_id%TYPE := 'CA';
  v_loc_id          locations.location_id%TYPE;
  v_new_city     locations.city%TYPE := 'Montreal';
BEGIN
  SELECT MAX(location_id) 
       INTO v_loc_id 
     FROM locations
   WHERE country_id = v_countryid;
   FOR i IN 1..3 LOOP
        INSERT INTO ubicaciones(location_id, city, country_id)   
        VALUES((v_loc_id + i), v_new_city, v_countryid );
   END LOOP;
END;

-- loops anidados

DECLARE
v_iddep_min NUMBER(3);
v_iddep_max NUMBER(3);
v_depto_emp NUMBER(3);
v_nom_emp VARCHAR2(30);
id_emp NUMBER(3);
BEGIN
 SELECT MIN(department_id), MAX(department_id)
   INTO v_iddep_min,v_iddep_max
   FROM departments;
   WHILE v_iddep_min <= v_iddep_max LOOP
         DBMS_OUTPUT.PUT_LINE('Departamento: ' || v_iddep_min);
         id_emp:=100;
         WHILE id_emp <= 206 LOOP
            SELECT first_name || ' ' || last_name, department_id
              INTO v_nom_emp, v_depto_emp
             FROM employees
             WHERE employee_id=id_emp;
             IF v_iddep_min = v_depto_emp THEN
                DBMS_OUTPUT.PUT_LINE('      ' || v_nom_emp);
             END IF;
             id_emp:=id_emp+1;
         END LOOP;
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
        v_iddep_min:=v_iddep_min+10;
    END LOOP;
  END;

/*
 Tipos de datos compuestos
Table, REcord , Nested, Table y Varray

*/

-- dlarar
DECLARE
 TYPE tipo_reg_empleado IS RECORD
    (id_emp           NUMBER(6) NOT NULL := 100,
     apell_emp      employees.last_name%TYPE,
     job_emp         employees.job_id%TYPE);
  reg_empleado  tipo_reg_empleado;

  --Tercero, acceder a los campos del registros por su nombre

nombre_registro.nombre_campo


DECLARE
   reg_empleado.job_id
   reg_empleado.job_emp:='ST_CLERK';



VAR b_porc_aumento NUMBER
EXEC :b_porc_aumento:=1.25
DECLARE
TYPE tipo_reg_empleado IS RECORD
(sal_prom NUMBER(7),
 id_emp_min NUMBER(3),
 id_emp_max NUMBER(3));
reg_empleado  tipo_reg_empleado;
v_tot_emp_act NUMBER(3):=0;
BEGIN
    -- consulta para obtener el salario promedio y guardarlos en reg_empleado
  SELECT ROUND(AVG(salary)),MIN(employee_id), MAX(employee_id)
    INTO reg_empleado
    FROM employees;    
    -- liego cpn el salario mini y el max crea el loop accediendo a los campos de reg_empleado
   FOR i IN reg_empleado.id_emp_min .. reg_empleado.id_emp_max LOOP
       UPDATE empleados
          SET salary=ROUND(salary*:b_porc_aumento)
        WHERE employee_id=i
          AND salary < reg_empleado.sal_prom;
          -- aqui dice que si el rowcount no hubo registro afectado suma 1 entonces suma 1 al total de empleados actualizados
        IF SQL%ROWCOUNT > 0 THEN
           v_tot_emp_act:=v_tot_emp_act+1;
        END IF;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Total de empleados actualizados: ' || v_tot_emp_act);
END;


-- Rowtype 
/*

El atributo %ROWTYPE se usa para declarar un registro que almacena una fila completa de un tabla o vista, ALMACENA ESA VARIABLE TODOS LOS DATOS DE UNA COLUMNA DE UNA TABLA O VISTA

*/


VAR id_emp NUMBER
EXEC :id_emp:=124
DECLARE
  reg_emp   employees%ROWTYPE; 
  -- reg_emp que es un registro cuyos campos son todas las columnas (nombres y tipos de datos) de la tabla EMPLOYEES
 BEGIN
 SELECT * INTO reg_emp
   FROM employees
  WHERE employee_id = :id_emp;
/* Se hace referencia en forma explícita a cada campo del registro para insertar sus valores en la tabla */
  INSERT INTO empleados_retirados
  VALUES (reg_emp.employee_id, reg_emp.first_name, reg_emp.last_name,
                  reg_emp.email, reg_emp.phone_number, reg_emp.hire_date, 
                  reg_emp.job_id, reg_emp.salary,  reg_emp.commission_pct, 
                  reg_emp.manager_id, reg_emp.department_id); 
/* Otra opción para insertar es usando el registro completo como se muestra a continuación. Con esta opción, la base de datos obtiene los valores de cada campo del registro y los inserta en ese mismo orden a la tabla.   */
   INSERT INTO empleados_retirados VALUES reg_emp;
COMMIT;
END;

-- otro ejemplo


VAR id_emp NUMBER
EXEC :id_emp:=124
DECLARE
reg_emp   employees%ROWTYPE; 
 BEGIN
    SELECT * 
      INTO reg_emp
      FROM employees
     WHERE employee_id = :id_emp;
    reg_emp.hire_date:=SYSDATE;
    reg_emp.salary:=15000;
   UPDATE empleados_retirados 
         SET ROW = reg_emp 
   WHERE employee_id= :id_emp;
   COMMIT;
END;

/*

La palabra reservada ROW se utiliza para representar a toda la fila de la tabla. En el bloque PL/SQL, se obtiene la fila completa del empleado 124 desde la tabla EMPLOYEES y los valores se almacenan en el registro reg_emp. Se le asignan nuevos valores a los campos hire_date y salary del registro (SYSDATE y 15000 respectivamente) para finalmente utilizar el registro completo y actualizar la fila completa del empleado 124 en la tabla EMPLEADOS_RETIRADOS.

*/

-- Tablas psql


DECLARE
TYPE tipo_tabla_apellido IS TABLE OF 
         employees.last_name%TYPE
         INDEX BY PLS_INTEGER;
TYPE tipo_tabla_hiredate IS TABLE OF 
           DATE
          INDEX BY PLS_INTEGER;
tabla_apellido tipo_tabla_apellido;
tabla_fecha_contrato tipo_tabla_hiredate;
BEGIN
 tabla_apellido(1) := 'CAMERON';
 tabla_fecha_contrato(8) := SYSDATE + 7;
   INSERT INTO datos_empleado
  VALUES(tabla_apellido(1), tabla_fecha_contrato(8));
  COMMIT;
END; 





VAR b_min_emp NUMBER
VAR b_max_emp NUMBER
EXEC :b_min_emp:=100
EXEC :b_max_emp:=104
DECLARE
TYPE tipo_tabla_emp IS TABLE OF
          employees%ROWTYPE 
          INDEX BY PLS_INTEGER;
tabla_emp  tipo_tabla_emp;
v_ind      NUMBER(3):=1; 
BEGIN
  FOR i IN :b_min_emp .. :b_max_emp
  LOOP
    SELECT * 
      INTO tabla_emp(v_ind) 
       FROM  employees
     WHERE employee_id = i;
    v_ind := v_ind +1;
  END LOOP;
  FOR i IN tabla_emp.FIRST .. tabla_emp.LAST 
  LOOP
     DBMS_OUTPUT.PUT_LINE('Fila N° ' || i  || ' de la tabla INDEX BY. Apellido: ' || tabla_emp(i).last_name || '  Salario:  ' || tabla_emp(i).salary);
  END LOOP;
END;

-- Varray


DECLARE
    -- Primero se declara el tipo de dato
   TYPE tipo_varray_location IS VARRAY(4) 
            OF locations.city%TYPE;
    -- Se declara la variable de esa varray
   varray_oficinas  tipo_varray_location;
   v_elementos    NUMBER(3); 
BEGIN
--SE declaran los elementos dentro de la varray

VAR b_por_aum1 NUMBER
VAR b_por_aum2 NUMBER
VAR b_por_aum3 NUMBER
EXEC :b_por_aum1:=1.25
EXEC :b_por_aum1:=1.15
EXEC :b_por_aum1:=1.05
DECLARE
TYPE tp_varray_porc_aum IS VARRAY(3) 
            OF NUMBER;
varray_porc_aum  tp_varray_porc_aum;
v_min_id_emp NUMBER(3);
v_max_id_emp NUMBER(3);
v_salario NUMBER(8);
v_sal_act NUMBER(8);
BEGIN
  varray_porc_aum:= tp_varray_porc_aum(:b_por_aum1,:b_por_aum2,:b_por_aum3);
  SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min_id_emp, v_max_id_emp
    FROM employees;
-- El bloque continúa en la siguiente PPT   
 varray_oficinas:= tipo_varray_location('Bombay','Tokyo','Singapore','Oxford');
    v_elementos:= varray_oficinas.COUNT();
    DBMS_OUTPUT.PUT_LINE('Elementos almacenados en el VARRAY');
    FOR i IN 1 .. v_elementos LOOP
        DBMS_OUTPUT.PUT_LINE(varray_oficinas(i));
    END LOOP;
END; 
 FOR i IN v_min_id_emp .. v_max_id_emp LOOP
      SELECT salary
        INTO v_salario
        FROM employees
        WHERE employee_id = i;
   IF v_salario < 5000 THEN
      v_sal_act:= ROUND(v_salario*varray_porc_aum(1));
   ELSIF v_salario < 15000 THEN
      v_sal_act:= ROUND(v_salario*varray_porc_aum(2));
   ELSE
      v_sal_act:= ROUND(v_salario*varray_porc_aum(3));
   END IF;
   UPDATE empleados
      SET salary=v_sal_act
       WHERE employee_id=i;
   END LOOP;
 END; 

-- cursores
/*

la sentencia SELECT con cláusula INTO puede retornar solo una fila. Entonces, ¿cómo se puede incorporar al bloque la sentencia SELECT que retorna más de una fila?. La respuesta es que en estos casos, se pueden declarar cursores explícitamente en función de las necesidades de negocio. 


Control de Cursores Explícitos
Para trabajar con un cursor explícito se requiere:
Declarar el cursor con la instrucción DECLARE asignándole un nombre y definiendo la estructura de la consulta que será asociada al cursor. Esto permite que se cree un área de SQL con nombre
Abrir el cursor con la instrucción OPEN que ejecuta la consulta y reemplaza cualquier variable que es referenciada. Las filas identificadas por la consulta son llamadas al set activo y ahora están disponibles para leerlas.
Recuperar los datos desde el cursor con la instrucción FETCH leyendo cada fila recuperada por el cursor.
Cerrar el cursor y liberar los recursos con la instrucción CLOSE: liberando así el set activo de filas. Esto hace posible reabrir el cursor para establecer un nuevo set activo.

*/

CURSOR nombre_cursor IS
                sentencia_select;

-- ejemplo 1
DECLARE
CURSOR cur_dato_empleado IS
  SELECT employee_id, e.first_name || ' ' || e.last_name, e.salary
    FROM employees e; 

-- ejemplo 2

DECLARE
CURSOR cur_empleados IS
       SELECT e.employee_id, 
                     e.first_name || ' ' ||
                      e.last_name, j.job_title, l.city, l.street_address
         FROM employees e JOIN jobs j
           ON(e.job_id = j.job_id)
         LEFT OUTER JOIN departments d
           ON(e.department_id = d.department_id)
         LEFT OUTER JOIN locations l
           ON(d.location_id = l.location_id)
        ORDER BY e.employee_id;

-- Abrir el Cursor

    OPEN nombreCursos;

    OPEN cur_empleados;

-- Declarar un cursos y luego abrir para recuperar los datos

DECLARE
CURSOR cur_dato_empleado IS
  SELECT employee_id, e.first_name || ' ' || e.last_name, e.salary
    FROM employees e; 
BEGIN
  OPEN cur_dato_empleado;


VAR b_salario NUMBER
EXEC :b_salario:=10000
DECLARE
CURSOR cur_empleados IS
       SELECT e.employee_id,e.first_name || ' ' || e.last_name, 
              j.job_title, l.city, l.street_address
         FROM employees e JOIN jobs j
           ON(e.job_id = j.job_id)
         LEFT OUTER JOIN departments d
           ON(e.department_id = d.department_id)
         LEFT OUTER JOIN locations l
           ON(d.location_id = l.location_id)
        WHERE e.job_id IN (SELECT job_id
                            FROM employees
                          GROUP BY job_id
                          HAVING ROUND(AVG(salary)) > :b_salario)                           
        ORDER BY e.employee_id;
BEGIN
  OPEN cur_empleados;



-- Leer Datos del CursorEl atributo %NOTFOUND permite validar si se han leído todas las filas del Set Activo del cursor
FETCH nombre_cursor INTO lista_de_variables | registro_PL/SQL;
 

DECLARE
CURSOR cur_dato_empleado IS
  SELECT employee_id, e.first_name || ' ' || e.last_name, e.salary
    FROM employees e; 
TYPE tipo_reg_empleado RECORD IS
     id NUMBER(3),
    nombre VARCHAR2(30),
    salario NUMBER(8));
reg_empleado  tipo_reg_empleado;
OPEN cur_dato_empleado;
--Se lee la fila actual del Set Activo del cursor y los datos se almacenan en las variables de la cláusula INTO
FETCH cur_dato_empleado INTO reg_empleado;
END;

--  Otro ejemplo

DECLARE
CURSOR cur_empleados IS
       SELECT e.employee_id, e.first_name || ' ' || e.last_name, 
                     j.job_title, l.city, l.street_address
         FROM employees e JOIN jobs j
           ON(e.job_id = j.job_id)
         LEFT OUTER JOIN departments d
           ON(e.department_id = d.department_id)
         LEFT OUTER JOIN locations l
           ON(d.location_id = l.location_id)
        ORDER BY e.employee_id;
v_id_emp NUMBER(3);
v_nombre VARCHAR2(30);
v_trabajo VARCHAR2(30);
v_ciudad VARCHAR2(30);
v_direcc VARCHAR2(30);
BEGIN
 OPEN cur_empleados;
 FETCH cur_empleados INTO v_id_emp, v_nombre,v_trabajo,v_ciudad,v_direcc;
END;

-- Leer datos de un cursos>


VAR b_salario NUMBER
EXEC :b_salario:=10000
DECLARE
CURSOR cur_empleados IS
       SELECT e.employee_id,e.first_name || ' ' || e.last_name, j.job_title, l.city, l.street_address
         FROM employees e JOIN jobs j
           ON(e.job_id = j.job_id)
         LEFT OUTER JOIN departments d
           ON(e.department_id = d.department_id)
         LEFT OUTER JOIN locations l
           ON(d.location_id = l.location_id)
        WHERE e.job_id IN (SELECT job_id
                            FROM employees
                          GROUP BY job_id
                          HAVING ROUND(AVG(salary)) > :b_salario)                           
        ORDER BY e.employee_id;
v_id_emp NUMBER(3);
v_nombre VARCHAR2(30);
v_trabajo VARCHAR2(30);
v_ciudad VARCHAR2(30);
v_direcc VARCHAR2(30);
BEGIN
  OPEN cur_empleados;
  FETCH cur_empleados INTO v_id_emp, v_nombre,v_trabajo,v_ciudad,v_direcc;
END;

--  Cerrar el Cursor

    CLOSE nombre_cursor;
    --Se cierra el cursor se, libera el área de contexto que se le asignó en memoria y el set activo se elimina

    -- Ejemplo    
    DECLARE
    CURSOR cur_dato_empleado IS
    SELECT e.employee_id, e.first_name || ' ' || e.last_name, e.salary
        FROM employees e; 
    TYPE tipo_reg_empleado RECORD IS
        id NUMBER(3),
        nombre VARCHAR2(30),
        salario NUMBER(8));
    reg_empleado  tipo_reg_empleado;
    BEGIN
        OPEN cur_dato_empleado;
        FETCH cur_dato_empleado INTO reg_empleado;
        CLOSE cur_dato_empleado;
    END;


--  Ejemplo


VAR b_salario NUMBER
EXEC :b_salario:=10000
DECLARE
CURSOR cur_empleados IS
       SELECT e.employee_id,e.first_name || ' ' || e.last_name, j.job_title, l.city, l.street_address
         FROM employees e JOIN jobs j
           ON(e.job_id = j.job_id)
         LEFT OUTER JOIN departments d
           ON(e.department_id = d.department_id)
         LEFT OUTER JOIN locations l
           ON(d.location_id = l.location_id)
        WHERE e.job_id IN (SELECT job_id
                            FROM employees
                          GROUP BY job_id
                          HAVING ROUND(AVG(salary)) > :b_salario)                           
        ORDER BY e.employee_id;
v_id_emp NUMBER(3);
v_nombre VARCHAR2(30);
v_trabajo VARCHAR2(30);
v_ciudad VARCHAR2(30);
v_direcc VARCHAR2(30);
BEGIN
    OPEN cur_empleados;
     FETCH cur_empleados INTO v_id_emp, v_nombre,v_trabajo,v_ciudad,v_direcc;
     CLOSE cur_empleados;
END;


-- Uso de Atributo %ROWTYPE

CURSOR nombre_cursor IS
                SELECT columna1, columna2, expression1 alias, columnaN|expresiónN;
nombre_registro   nombre_cursor%ROWTYPE;

ejemplo

DECLARE
CURSOR cur_datos_emp IS
    SELECT  e.employee_id id_emp, 
            e.salary, 
            ROUND(MONTHS_BETWEEN(SYSDATE,e.hire_date)/12) annos_trab
    FROM employees e
    ORDER BY e.employee_id;
v_bonif_annos NUMBER(8);
reg_datos_emp  cur_datos_emp%ROWTYPE;
-- El bloque continúa en la siguiente PPT
BEGIN
  OPEN cur_datos_emp;
  LOOP
  FETCH cur_datos_emp INTO reg_datos_emp;
  EXIT WHEN cur_datos_emp%NOTFOUND;
  -- Calcula bonificación por años trabajados
     IF reg_datos_emp.annos_trab >=18 THEN
       SELECT ROUND(reg_datos_emp.salary*(porc_bonif/100)) 
         INTO v_bonif_annos
         FROM tramo_bonif_annos_trab
        WHERE reg_datos_emp.annos_trab BETWEEN rango_ini AND rango_fin;
    --Se actualiza el salario si el empleado tiene 18 o más años trabajando
     UPDATE empleados
        SET salary= reg_datos_emp.salary + v_bonif_annos
      WHERE employee_id=reg_datos_emp.id_emp;    
    END IF;
    COMMIT;
 END LOOP;
END; 


-- Cursor FOR LOOP usando Subconsulta
DECLARE
FOR nombre_registro IN (sentencia_select)
LOOP 
/* Procesamiento del SET ACTIVO del Cursor y ejecución de sentencias SQL y PL/SQL*/    
END LOOP;



DECLARE
v_bonif_annos NUMBER(8);
BEGIN
  FOR reg_datos_emp IN (
    SELECT e.employee_id id_emp, e.salary,
    ROUND(MONTHS_BETWEEN(SYSDATE,e.hire_date)/12) annos_trab
    FROM employees e
    ORDER BY e.employee_id)
  LOOP
 -- Calcula bonificación por años trabajados
     IF reg_datos_emp.annos_trab >=18 THEN
       SELECT ROUND(reg_datos_emp.salary*(porc_bonif/100)) 
         INTO v_bonif_annos
         FROM tramo_bonif_annos_trab
        WHERE reg_datos_emp.annos_trab BETWEEN rango_ini AND rango_fin;
    --Se actualiza el salario si el empleado tiene 15 o más años trabajando
     UPDATE empleados
        SET salary= reg_datos_emp.salary + v_bonif_annos
      WHERE employee_id= reg_datos_emp.id_emp;    
     COMMIT;
    END IF;
 END LOOP;
END; 




-- Subprograma PL/SQL
/*

PL / SQL tiene dos tipos de subprogramas: Procedimientos Almacenados y Funciones Almacenadas. Normalmente, se utiliza un Procedimiento para realizar el procesamiento de información y una Función para realizar una acción devolver un valor. 


*/

-- Pude ser PROCEDURE (para crear un Procedimiento) FUNCTION (para crear una Función).
CREATE [OR REPLACE] tipo_subprograma nombre_subprograma
 [(parámetro1 [modo] tipo_dato1,
   parámetro2 [modo] tipo_dato2, ...)]

IS|AS /*
  subprogramas no se inicia con la palabra clave DECLARE. Esta va a continuación de la palabra IS o AS y en ella se definen variables, constantes, cursores y excepciones. 
  */
  [declaración_variables_locales; …]
BEGIN  -- Sentencias ejecutables SQL y PL/SQL                Bloque PL/SQL estándar
[EXCEPTION]  -- Sentencias control de excepciones
END [nombre_procedimiento];


-- Crear un Procedimiento Almacenado

CREATE [OR REPLACE] PROCEDURE nombre_procedimiento
    --modo: define con es usado un parámetro: IN (defecto), OUT o IN OUT.
 [(parámetro1 [modo] tipo_dato1, parámetro2 [modo] tipo_dato2, ...)]

IS|AS
  [declaración_variables_locales; …]
BEGIN -- Sentencias ejecutables SQL y PL/SQL                Bloque PL/SQL estándar
[EXCEPTION] -- Sentencias control de excepciones
END [nombre_procedimiento];


-- Ejemplo:


CREATE OR REPLACE PROCEDURE SP_INSERT_EMP_RETIRADO IS
reg_emp   employees%ROWTYPE; 
v_id_emp NUMBER:=124;
 BEGIN
 SELECT * INTO reg_emp
   FROM employees
  WHERE employee_id = v_id_emp;
/* Se hace referencia en forma explícita a cada campo del registro para insertar sus valores en la tabla */
  INSERT INTO empleados_retirados
  VALUES (reg_emp.employee_id, reg_emp.first_name, reg_emp.last_name,
                  reg_emp.email, reg_emp.phone_number, reg_emp.hire_date, 
                  reg_emp.job_id, reg_emp.salary,  reg_emp.commission_pct, 
                  reg_emp.manager_id, reg_emp.department_id); 
/* Otra opción para insertar es usando el registro completo como se muestra a continuación. Con esta opción, la base de datos obtiene los valores de cada campo del registro y los inserta en ese mismo orden a la tabla.   */
   INSERT INTO empleados_retirados VALUES reg_emp;
COMMIT;
END;

-- UTILIZAR UN PROCEDIMIENTO ALMACENADO
EXEC NOMBREPROCEDIMIENTO;

EXEC SP_INSERT_EMP_RETIRADO ;

-- otra forma desde un bloque anonimo
BEGIN
   SP_INSERT_EMP_RETIRADO ;
END;

-- eliminar procedimiento
DROP PROCEDURE nombre_procedimiento;


-- Parámetros Formales

CREATE OR REPLACE PROCEDURE SP_ACTUALIZA_EMP_RET
-- declaración de parámetros que se pasan como argumentos
(p_id_emp NUMBER, p_fecha_cont DATE, p_salario NUMBER) IS
 BEGIN
    -- luego se utiliza el parámetro como variable local
   UPDATE empleados_retirados 
         SET hire_date = p_fecha_cont,
             salary = p_salario 
       WHERE employee_id= p_id_emp ;
   COMMIT;
END;

-- UTILIZACIÓN DE ESTE PROCEDIMINETO CON LAS VARIABLES DECLARADAS 
--  (p_id_emp NUMBER, p_fecha_cont DATE, p_salario NUMBER)
EXEC  SP_ACTUALIZA_EMP_RET(124,SYSDATE,15000);

-- oTRA FORMA DE DECLARAR LOS PARAMETROS
CREATE OR REPLACE PROCEDURE SP_ACTUALIZA_SALARIO
(p_por_aum1 employees.salary%TYPE,
p_por_aum2 IN NUMBER) AS
CURSOR cur_datos_emp IS

--SE EJECUTA:

EXEC  SP_ACTUALIZA_SALARIO(25,15);
 
-- O

BEGIN
    SP_ACTUALIZA_SALARIO(25,15);
END;


-- PROCEDIMIENTO CON IN AND OUT

CREATE OR REPLACE PROCEDURE SP_ACTUALIZA_SALARIO
(p_por_aum1 employees.salary%TYPE,
p_por_aum2 IN NUMBER,
p_filas_proc OUT NUMBER) AS
CURSOR cur_datos_emp IS

-- COMO SE UTILIZARIA ESTE EJERCICIO

DECLARE
v_resultado NUMBER(3);
BEGIN
    SP_ACTUALIZA_SALARIO(25,15,v_resultado);
    DBMS_OUTPUT.PUT_LINE('Total de empleados actualizados: ' || v_resultado);
END;

-- O CUANDO EL PARAMETRO IENE ENTRADA Y SALIDA 

CREATE OR REPLACE PROCEDURE SP_ACTUALIZA_SALARIO
(p_por_aum1 employees.salary%TYPE,
p_por_aum2 IN OUT NUMBER) AS

DECLARE
v_param2 NUMBER(3):=15;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Valor de entrada al parámetro IN OUT: ' || v_param2);
    SP_ACTUALIZA_SALARIO(25,v_param2);
    DBMS_OUTPUT.PUT_LINE('Valor de salida del parámetro IN OUT: ' || v_param2);
END;



-- Dif entre func y proc, la func devuelve algo https://www.plsql.biz/2007/03/procedimientos-y-funciones-en-plsql.html


-- FUNCIONES


CREATE [OR REPLACE] FUNCTION nombre_función [(parámetro1 [modo1] tipo_dato1, ...)]
RETURN tipo_dato IS|AS

 [declaración_variables_locales; …]
BEGIN -- Sentencias ejecutables SQL y PL/SQL
 RETURN expresión
[EXCEPTION]                                                                  Bloque PL/SQL estándar   -- Sentencias control de excepciones
  [RETURN expresión] 
END [nombre_función];




CREATE OR REPLACE FUNCTION FN_OBT_ANNOS_TRAB
(p_id_emp   NUMBER) RETURN NUMBER IS
v_annos_trab NUMBER(2):=0;
v_mensaje_error VARCHAR2(100);
/*  Retorna un numero en promera instancia, pero si sale un errir devolvera un varchar2     */  
BEGIN
    SELECT ROUND(MONTHS_BETWEEN(SYSDATE,e.hire_date)/12) 
      INTO v_annos_trab
      FROM employees e       
     WHERE e.employee_id = p_id_emp;
    RETURN v_annos_trab;
EXCEPTION
WHEN OTHERS THEN
   v_mensaje_error:=SQLERRM;
   INSERT INTO error_proceso
   VALUES (SEQ_ERROR_PROC.NEXTVAL,'ERROR en FN_OBT_ANNOS_TRAB para el empleado ' || p_id_emp,                                      	v_mensaje_error); 
   RETURN 0;
END FN_OBT_ANNOS_TRAB;

-- usando funcion 

SELECT employee_id, hire_date, 
              FN_OBT_ANNOS_TRAB(employee_id) "AÑOS CONTRATADO"
FROM employees
ORDER BY employee_id;


SELECT employee_id "ID EMP", salary salario,
       FN_OBT_MONTO_BONO_ANNO(employee_id,salary, FN_OBT_ANNOS_TRAB(employee_id)) "BONO AÑOS"
FROM employees
WHERE employee_id=100;

-- otro ejemplo


CREATE OR REPLACE FUNCTION FN_JEFE_EMPLEADOS(p_id_jefe NUMBER) RETURN NUMBER IS
v_total_emp NUMBER(2);
BEGIN
  SELECT COUNT(*)
    INTO v_total_emp
    FROM employees
    WHERE manager_id=p_id_jefe;
   RETURN v_total_emp;
END;


SELECT DISTINCT m.manager_id, e.last_name, 
               FN_JEFE_EMPLEADOS(m.manager_id) "TOTAL EMPLEADOS"
 FROM employees e JOIN employees m
      ON m.manager_id=e.employee_id
 ORDER BY m.manager_id;


SELECT m.manager_id "ID JEFE",
              m.employee_id "ID EMPLEADO", 
              m.first_name || ' ' || m.last_name "NOMBRE EMPLEADO"
 FROM employees e JOIN employees m
       ON m.manager_id=e.employee_id
WHERE FN_JEFE_EMPLEADOS(m.manager_id) = 
                                                                                        (SELECT MAX(FN_JEFE_EMPLEADOS(manager_id))
                                                                                            FROM employees)
ORDER BY m.last_name;


-- Package

CREATE [OR REPLACE] PACKAGE nombre_package IS|AS
    declaración de tipos y variables públicos
    especificación de procedimientos y/o funciones
END [nombre_package];


CREATE OR REPLACE PACKAGE PKG_PROC_REMUN IS
v_mensaje_error VARCHAR2(200);
v_rutina_error VARCHAR2(200);
v_sec_err NUMBER(8):=0;
CURSOR cur_emp_trabaja IS
                SELECT e.employee_id, COUNT(m.employee_id) total_emp, 
                              e.salary salario, ROUND(e.salary*NVL(e.commission_pct,0)) valor_comision, l.city
                  FROM employees e LEFT JOIN employees m
                        ON(e.employee_id=m.manager_id)
                   LEFT OUTER JOIN departments d
                        ON(e.department_id = d.department_id)
                   LEFT OUTER JOIN locations l
                        ON(d.location_id = l.location_id)
                    GROUP BY e.employee_id,e.salary,e.commission_pct, l.city
                    ORDER BY e.employee_id; 
FUNCTION F_OBT_DESCTO_SINDICATO(p_sueldo_base NUMBER, p_id_empleado NUMBER) RETURN NUMBER;
PROCEDURE P_GRABAR_ERROR(p_rutina_error VARCHAR2, p_mensaje_error VARCHAR2);
END PKG_PROC_REMUN ;




CREATE OR REPLACE PACKAGE BODY PKG_PROC_REMUN IS
FUNCTION F_OBT_DESCTO_SINDICATO(
p_sueldo_base NUMBER, 
p_id_empleado NUMBER) RETURN NUMBER IS
v_valor_descto_sin NUMBER(5):=0;
BEGIN
     SELECT ROUND(p_sueldo_base * tds.porc_ds)
       INTO v_valor_descto_sin
       FROM tramo_descto_sindicato tds
      WHERE p_sueldo_base BETWEEN tds.tramo_inf_ds AND tds.tramo_sup_ds;
      RETURN v_valor_descto_sin;
EXCEPTION
WHEN OTHERS THEN
     v_mensaje_error :=SQLERRM;
     v_rutina_error :='Error en la Función F_OBT_DESCTO_SINDICATO del Package. Empleado: ' || p_id_empleado;
     P_GRABAR_ERROR(v_rutina_error, v_mensaje_error);
     RETURN 0; 
END F_OBT_DESCTO_SINDICATO;
PROCEDURE P_GRABAR_ERROR(p_rutina_error VARCHAR2, p_mensaje_error VARCHAR2) IS
BEGIN
   v_sec_err := v_sec_err +1;
    INSERT INTO error_proceso
           VALUES(v_sec_err,p_rutina_error,p_mensaje_error);
END P_GRABAR_ERROR;
END PKG_PROC_REMUN ;

-- invocando el Package

SELECT employee_id "IDENT. EMPLEADO", salary salario,
 PKG_PROC_REMUN.F_OBT_DESCTO_SINDICATO(salary,employee_id) "DESCUENTO SINDICATO"
  FROM employees
WHERE employee_id=100;


-- Trigger

CREATE [OR REPLACE] TRIGGER nombre_trigger
 {BEFORE | AFTER}
  {INSERT | [OR] DELETE | [OR] UPDATE | [OR]UPDATE OF lista_columnas }
ON nombre_tabla
[[REFERENCING OLD AS old | NEW AS new ]
[FOR EACH ROW]
[WHEN (condición)]
[DECLARE variables]]
[CALL nombre_procedimiento]
BEGIN
  sentencias_ejecutables
[EXCEPTION ... ]
END [nombre_trigger];


-- ejemplo

CREATE OR REPLACE TRIGGER TRG_SEGURIDAD_EMP
BEFORE INSERT ON empleados 
BEGIN
IF (TO_CHAR(SYSDATE,'HH24:MI') NOT BETWEEN '08:00' AND '18:00') THEN
      RAISE_APPLICATION_ERROR(-20500, 
      'Se debe insertar en tabla EMPLEADOS sólo durante horas de trabajo.');
   END IF;
END;

-- otto ejemplo

CREATE OR REPLACE TRIGGER TRG_VALIDA_DML_EMP 
BEFORE INSERT OR UPDATE OR DELETE ON empleados BEGIN
 IF TO_CHAR(SYSDATE,'HH24')  NOT BETWEEN '08' AND '18' THEN
       IF DELETING THEN 
           RAISE_APPLICATION_ERROR(-20502, 'Se debe eliminar desde tabla EMPLEADOS sólo durante horas de trabajo.');
       ELSIF INSERTING THEN 
            RAISE_APPLICATION_ERROR(-20500, 'Se debe insertar en tabla EMPLEADOS solo durante horas de trabajo.');
       ELSIF UPDATING('SALARY') THEN
           RAISE_APPLICATION_ERROR(-20503, 'Se debe actualizar salario sólo durante horas de trabajo.');
       END IF;
 END IF;
END;

-- TRIGGER CON OLD AND NEW 
/* 

La estructura OLD almacena los valores originales que la fila que se está procesando tiene en la tabla

La estructura NEW almacena los nuevos valores de esa misma fila. Se mantienen los valores originales de las columnas que no son actualizadas

 Para hacer referencia a cada uno de los valores de estos 
pseudo-registros  deben ir precedidos por : (:OLD y :NEW), excepto en la condición WHEN



*/


CREATE OR REPLACE TRIGGER TRG_AUDIT_EMP
AFTER INSERT OR UPDATE OR DELETE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO audit_emp(user_name, old_employee_id, new_employee_id, 
    old_last_name, new_last_name, old_job_id, new_job_id, 
    old_salary, new_salary)
    VALUES (USER, :OLD.employee_id, :NEW.employee_id, 
    :OLD.last_name, :NEW.last_name, :OLD.job_id, :NEW.job_id, 
    :OLD.salary, :NEW.salary);
END;

INSERT INTO empleados (employee_id, first_name, last_name, email,  hire_date, job_id, salary)
VALUES(999, 'Ruth', 'Soto','RSOTO', sysdate, 'AD_ASST', 4000);


CREATE OR REPLACE TRIGGER TRG_U_PRESTAMO_SOCIAL 
BEFORE UPDATE ON PRESTAMO_SOCIAL 
FOR EACH ROW 
BEGIN
   IF :NEW.fecha_pago > :OLD.fecha_venc_prestamo  THEN
     :NEW.multa:= ROUND(:OLD.valor_prestamo * ((:NEW.fecha_pago -             
                                               :OLD.fecha_venc_prestamo)/100));
     :NEW.estado_pago:= 'El valor de la multa correspnde a ' || 
                                              (TO_DATE(TO_CHAR(:NEW.fecha_pago,'dd/mm/yyyy'))-  
                                              TO_DATE(to_char(:OLD.fecha_venc_prestamo,'dd/mm/yyyy'))) 
                                            || ' dias de atraso. La multa corresponde a un ' || 
                                            (:NEW.fecha_pago - :OLD.fecha_venc_prestamo) 
                                           || ' % del valor del préstamo';
  END IF;
END;  