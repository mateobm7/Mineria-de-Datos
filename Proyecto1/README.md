# Proyecto1 Mineria de Datos

## 1. Enunciado del problema.

Transición Planetaria: Usando la base de datos Exoplanet Archive, use su endpoint para descargar la base de datos ideal utilizando SQL para poder realizar un gráfico de Masa vs Radio. Identificar dónde los planetas dejan de ser rocosos densos y pasan a ser gigantes gaseosos esponjosos.

## 2. Explicación del contenido del repositorio

Antes de iniciar el análisis, el repositorio contiene lo siguiente:

- `pipeline.sh` → Script de Bash que automatiza todo. Debe descargar el CSV, ejecutar el script de bases de datos y luego el de graficación.
  - `constructor_db.py` → Script de Python que use Pandas para leer el CSV crudo, lo limpie de ser necesario, y lo guarde en una base de datos local SQLite llamada datos_mision.db.
  - `analisis_visual.py` → Script de Python que se conecta a datos_mision.db, extrae los datos usando una consulta SQL, realice los cálculos matemáticos y genera una imagen (resultado.png).
- `README.md` → Análisis de los resultados

Para ejecutar el pipeline (en bash), simplemente siga los siguientes pasos en la terminal, de enter en cada linea:
- `git clone https://github.com/mateobm7/Mineria-de-Datos`
- `cd Mineria-de-Datos/`
- `cd Proyecto1/`
- `chmod +x pipeline.sh`
- `sh pipeline.sh`

Con lo anterior debería generarse la gráfica.

## 3. Análisis de resultados

<img width="1100" height="800" alt="resultado" src="https://github.com/user-attachments/assets/183acb3e-92ab-469d-a07d-658bd7528a28" />

En la gráfica observamos dos secciones, la de color naranja me enseña los planetas gaseosos y los puntos azules serán planetas rocosos. 

Sobre estas distribuciones cruza una linea punteada de color verde, esta linea corresponde a un límite de densidad igual a $\rho = 3$ $g/cm^3$, todo lo que esté por arriba tendrá una menor densidad (naranja) y todo lo que esté abajo tendrá una mayor densidad (azul). Este limite de densidad no fue escogido al azar, diferentes observaciones me señalan este como un buen límite para definir que un planeta debajo de esta densidad dificilmente puede ser rocoso.

Claramente existen excepciones, y solo basarnos en la masa y el radio para definir si un planeta es rocoso o gaseoso puede ser algo complicado, no es suficiente para definir la naturaleza del planeta, lo cual es importante para ver realmente cómo es, a este mismo par de datos (radio-masa) pueden corresponder distintas composiciones del planeta, como por ejemplo:

- Presencia de agua o hielos.
- Presencia de una envoltura ligera o significativa.
- No se tiene en cuenta la cantidad de hierro, silicatos y gas que pueda tener el planeta.
- Planetas cerca de sus estrellas pueden tener variaciones en su radio pero no en su masa

Ahora, volviendo un poco a la gráfica, la linea verde no es un límite tajante, sino que alrededor de ella se produce la transición entre rocoso y gaseoso como lo pueden ser las super-tierras o mini-neptunos, por supuesto existen casos extremos, por ejemplo el caso del exoplaneta TOI-849b, que tiene una densidad similar a la tierra pero es gigante, del tamaño de neptuno, es poco lógico que un planeta tan grande sea tan denso ya que empieza a acumular mucho gas. En estos casos ya se recurre a análisis distintos, como por ejemplo que sí es un planeta gaseoso, pero perdió su atmósfera por el viento solar y lo que vemos es el núcleo de un gaseoso, muy interesante para analizar.

Como conclusión, vemos que clasificar si un planeta es rocoso o gaseoso por su densidad es una muy buena aproximación, sería muy útil tener algo de idea de su composición pero muchas veces es imposible, y analizar los casos extremos que no siguen mucho el modelo da paso a descubrir una nueva física muy interesante.




