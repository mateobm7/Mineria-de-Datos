# proyecto2_MineriaDatos

## 1. Enunciado del problema

`Arqueología Galáctica y el Misterio de Omega Centauri:` Omega Centauri no es un cúmulo globular ordinario. Muchos astrónomos creen que es el núcleo remanente de una galaxia enana que fue devorada por nuestra Vía Láctea hace miles de millones de años. Para probar esto, debemos separar las estrellas que pertenecen al cúmulo de las estrellas de la Vía Láctea que simplemente se cruzan visualmente frente a él. Lo haremos usando “Cinemática” (su movimiento en el cielo). Se debe hacer la gráfica del movimiento propio, detectar a Omega centauri y filtrar las estrellas que lo componenen, luego hacer un diagrama HR con las estrellas del cúmulo.


Descripción de lo que se hace:

- Parte 1 

Se crea un script llamado 1_descarga_omega.sh.

Se escribe una consulta ADQL para el catálogo Gaia DR3 en VizieR.

Se hace un CIRCLE search (CONTAINS) centrado en las coordenadas que encontraste en SIMBAD, con un radio de 0.5 grados.

Se extraen las columnas: Source, RA_ICRS, DE_ICRS, pmRA, pmDE, Gmag, BPmag, RPmag.

Se usa wget en el script para descargar el archivo y guárdalo como omega_bruto.csv.

- Parte 2

Se crea un script 2_crear_db.py.

Se usa Pandas para leer el CSV y limpiar cualquier fila que tenga valores nulos (NaN) en los movimientos propios (pmRA, pmDE) o fotometría.

Se usa la librería sqlite3 para crear una base de datos local llamada arqueologia.db.

Se transfiere el DataFrame limpio a una tabla SQL llamada estrellas.

- Parte 3

Se crea un script 3_analisis.py.

Se conecta a arqueologia.db y extrae los datos.

Se hacen las diferentes gráficas del movimiento propio, se analiza y se detecta a Omega centauri.

Se hace un filtrado SQL avanzado para extraer únicamente las estrellas que pertenecen al cúmulo.

Con las estrellas filtradas cinemáticamente se calcula el índice de color ($BP - RP$) y se grafica el Diagrama Color-Magnitud ($Color$ vs $Gmag$ invertido).

Se discute en el README.md cómo el diagrama HR se ve mucho más limpio al quedarnos solo con Omega Centauri usando SQL sin contar las estrellas de campo de la galaxia.

## 2. Explicación del contenido del repositorio

Antes de iniciar el análisis, el repositorio contiene lo siguiente:

- `1_descarga_omega.sh` → El cual me genera lo siguiente:
    - `omega_bruto.csv` → Archivo que contiene la base de datos hecha con ADQL llamando a Gaia DR3 en VizieR. (Puede demorarse un poco en descargar)
    - `2_crear_db.py` → Script que limpia los datos y los guarda en SQLite:
        - `arqueologia.db` → Archivo que contiene la base de datos local.
    - `3_analisis.py` → Script que realiza cálculos y genera las gráficas:
        - Primero me genera 3 gráficas asociadas al movimiento propio.
        - Segundo me genera 2 gráficas asociadas al diagrama color magnitud.
- `README.md` → Análisis de los resultados

Para ejecutar el pipeline simplemente hacer lo siguiente (bash):

- `chmod +x 1_descarga_omega.sh`
- `sh 1_descarga_omega.sh`

Con lo anterior deberían generarse las graficas, primero vienen 3 juntas y al cerrar la ventana aparecen las otras dos.

## 3. Análisis de resultados

<img width="1793" height="589" alt="image" src="https://github.com/user-attachments/assets/e9de0efa-9eab-4cfa-a44e-0e9c2fab2b05" />

Expliquemos rápidamente estas gráficas, la primera representa el movimiento propio de las estrellas contenidas en el cono formado por las coordenas de RA: 201.6970°, DEC: -47.4795° en un radio de 0.5°, la idea es encontrar a ojo el "racimo" que me representa a Omega Centauri, pero a simple vista es imposible, así que se decidió hacer un rápido mapa de densidad (segunda gráfica) para ver la región de mayor densidad (El punto amarrillo) la cual corresponde a Omega centauri. Se le hizo zoom a esta región (Gráfica 3) y encontramos a Omega centauri.


<img width="1398" height="552" alt="image" src="https://github.com/user-attachments/assets/8ee31124-975f-4d65-b300-361c225af390" />

En las siguientes dos gráficas tenemos el diagrama HR, antes y después de remover las estrellas intrusas de Omega Centauri, vemos claramente que no se pierde la estructura, por obvias razones sigue representando perfectamente un diagrama HR, pero lo que sí observamos es cómo en la imagen filtrada ya no hay tanta cantidad de estrellas que me ensanchan falsamente las secuencias, esto se da porque quitamos muchas estrellas que no pertenecían al cúmulo sino que son estrellas de campo de la Vía Láctea. Recalcando que bajaron notoriamente las estrellas aisladas, y vemos una muchísimo mejor definición de la secuencia principal. Claramente hay todavía algunas estrellas intrusas, pero esto es normal debido a que solo hicimos un filtro de SQL teniendo en cuenta el movimiento propio, para un análisis más robusto habría que tener en cuenta otro tipo de criterios.

Por último, al analizar las dos gráficas vemos que se perdió una pequeña ramificación después del filtrado (círculos rojos), esto puede deberse a que después del filtrado ya no se nota tanta mezcla de poblaciones, y esa ramificación corresponde a estrellas más brillantes y relativamente azules, por lo que son muy jóvenes para formar parte de un cúmulo globular tan definido como Omega Centauri.
