#!/bin/bash

#1. Descargo los datos

echo "Decargando la base de datos y realizando los calculos"

wget -q -O exoplanetas.csv "https://exoplanetarchive.ipac.caltech.edu/TAP/sync?query=SELECT+pl_name,pl_rade,pl_bmasse+FROM+ps+WHERE+pl_rade+IS+NOT+NULL+AND+pl_bmasse+IS+NOT+NULL&amp;format=csv"




#2. base de datos
cat << 'EOF' > constructor_db.py
import pandas as pd
import sqlite3

df = pd.read_csv('exoplanetas.csv')

df = df.dropna(subset=['pl_rade', 'pl_bmasse'])

conn = sqlite3.connect('datos_mision.db')

df.to_sql('exoplanetas', conn, if_exists='replace', index=False)
conn.close()
EOF

python3 constructor_db.py



#3. visualización
cat << 'EOF' > analisis_visual.py
import sqlite3
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

conexion = sqlite3.connect('datos_mision.db')

consulta = "SELECT pl_rade, pl_bmasse FROM exoplanetas;"

df = pd.read_sql_query(consulta, conexion)

conexion.close()
#1. creamos una linea que nos separe los planetas por densidad
densidad_tierra = 5.51 #g/cm**3
densidad_limite = 3.0 #g/cm**3

rango_masas = np.logspace(np.log10(df["pl_bmasse"].min()),
                          np.log10(df["pl_bmasse"].max()),
                          100)
linea_densidad = ((densidad_tierra / densidad_limite) * rango_masas) ** (1/3)


#2. Separamos los planetas que tengan una densidad mayor o menor a la límite (3g/cm**3) 
#esto para separar mejor los colores
curva_planetas = ((densidad_tierra / densidad_limite) * df["pl_bmasse"]) ** (1/3)

planetas_arriba = df["pl_rade"] >= curva_planetas   
planetas_abajo = df["pl_rade"] < curva_planetas  



#3. graficamos
plt.figure(figsize=(11, 8))

plt.scatter(
    df.loc[planetas_abajo, "pl_bmasse"],
    df.loc[planetas_abajo, "pl_rade"],
    s=20,
    alpha=0.8,
    label="Planetas rocosos")

plt.scatter(
    df.loc[planetas_arriba, "pl_bmasse"],
    df.loc[planetas_arriba, "pl_rade"],
    s=20,
    alpha=0.8,
    label="Planetas gaseosos")

# Dibujar la curva de densidad
plt.plot(
    rango_masas,
    linea_densidad,
    linestyle="--",
    linewidth=2,
    label=r"Curva de densidad $\rho = 3\ \mathrm{g/cm^3}$ $\approx 0.5\rho_\oplus$ ",
    color="green"
)

plt.xscale("log")
plt.yscale("log")
plt.xlabel(r"Masa [$M_\oplus$]")
plt.ylabel(r"Radio [$R_\oplus$]")
plt.title("Masa vs Radio Exoplanetas")
plt.grid(True, which="both", linestyle=":", alpha=0.35)
plt.legend()
plt.savefig("resultado.png")
plt.show()
EOF

python3 analisis_visual.py

echo "Imagen creada: resultado.png"

