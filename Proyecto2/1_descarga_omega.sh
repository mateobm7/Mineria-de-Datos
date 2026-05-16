# !/bin/bash
# Anunciamos el inicio del proceso


########Parte 1, creamos el ADQL para descargar la base de datos.
echo "1. Consultando VizieR TAP mediante ADQL..."
ADQL="SELECT Source, RA_ICRS, DE_ICRS, pmRA, pmDE, Gmag, BPmag, RPmag FROM \"I/355/gaiadr3\" WHERE 1=CONTAINS(POINT('ICRS', RA_ICRS, DE_ICRS), CIRCLE('ICRS', 201.6970, -47.4795, 0.5))"

# Reemplazamos los espacios por '+' usando 'sed' para que la URL no se rompa en internet
URL_ADQL=$(echo $ADQL | sed 's/ /+/g')
# Definimos el Endpoint base de VizieR
TAP_URL="https://tapvizier.cds.unistra.fr/TAPVizieR/tap/sync?request=doQuery&lang=ADQL&format=csv&query="

#Ejecutamos wget combinando el Endpoint y la consulta codificada
wget -q -O omega_bruto.csv "$TAP_URL$URL_ADQL"
#echo "Descarga finalizada"




########Parte 2, limpiamos el csv y creamos la base de datos local en sqlite 
cat << 'EOF' > 2_crear_db.py
import pandas as pd
import matplotlib.pyplot as plt
import sqlite3

df_crudo = pd.read_csv('omega_bruto.csv')

df = df_crudo.dropna(subset=['pmRA','pmDE', 'Gmag','BPmag','RPmag'])

conn = sqlite3.connect('arqueologia.db')
df.to_sql('estrellas', conn, if_exists='replace', index=False)
conn.close()
EOF


python3 2_crear_db.py






###########Parte 3, Graficas del movimiento propio
cat << 'EOF' > 3_analisis.py
import pandas as pd
import matplotlib.pyplot as plt
import sqlite3
import seaborn as sns

#Nos conectamos a la base de datos local
conexion = sqlite3.connect('arqueologia.db')

consulta = "SELECT pmRA, pmDE FROM estrellas;"

df = pd.read_sql_query(consulta, conexion)

conexion.close()


sns.set_theme(style="whitegrid", context="talk")
fig, axes = plt.subplots(1, 3, figsize=(15, 5), dpi=120)
# --------------------
# Gráfica 1, Grafica de los movimientos propios de todas las estrellas consultadas (sin filtar por mov. propio)
ax = axes[0]
ax.scatter(df["pmRA"], df["pmDE"], s=20)
ax.set_title("Movimientos propios")
ax.set_xlabel("pmRA [mas/yr]")
ax.set_ylabel("pmDE [mas/yr]")
ax.set_xlim(-50, 20)
ax.set_ylim(-40, 40)

# --------------------
# Gráfica 2, Grafica que me representa la densidad de estrellas
ax = axes[1]
hb = ax.hexbin(
    df["pmRA"],
    df["pmDE"],
    gridsize=80,
    cmap="viridis",
    mincnt=1
)
ax.set_xlim(-100, 80)
ax.set_ylim(-75, 50)
ax.set_xlabel(r"$\mu_{\alpha*}$ (pmRA)")
ax.set_ylabel(r"$\mu_{\delta}$ (pmDE)")
ax.set_title("Mapa de densidad")
cbar = fig.colorbar(hb, ax=ax)
cbar.set_label("Número de estrellas")

# --------------------
# Gráfica 3, Grafica  de Omega centauri
ax = axes[2]
ax.scatter(df["pmRA"], df["pmDE"], s=1)
ax.set_title("Movimientos propios (zoom)")
ax.set_xlabel("pmRA [mas/yr]")
ax.set_ylabel("pmDE [mas/yr]")
ax.set_xlim(-6, -1)
ax.set_ylim(-9, -4)
plt.tight_layout()
plt.show()






###################Parte 4, Graficas del CMD filtrado y sin filtrar
conexion = sqlite3.connect('arqueologia.db')

#Consulta sin filtar
consulta1 = "SELECT pmRA, pmDE, BPmag, RPmag, Gmag FROM estrellas;"

#consulta filtrada, se tomaron solo las estrellas dentro de un circulo, el circulo fue hecho a ojo después
#de ver la imagen 3 con zoom, se escogió un centro y un radio tentativo, el cual encierra a Omega Centauri
consulta2 = "SELECT pmRA, pmDE, BPmag, RPmag, Gmag FROM estrellas WHERE ((pmRA + 3.2)*(pmRA + 3.2))/(1.5*1.5) + ((pmDE + 6.6)*(pmDE + 6.6))/(1.5*1.5) < 1;"


df = pd.read_sql_query(consulta1, conexion)
datos_filtrados = pd.read_sql_query(consulta2, conexion)

conexion.close()


#Calculo índices de color
df["color"] = df["BPmag"] - df["RPmag"]
datos_filtrados["color"] = datos_filtrados["BPmag"] - datos_filtrados["RPmag"]


fig, axes = plt.subplots(1, 2, figsize=(12, 5), dpi=120)
# --------------------
# Grafica 1, CMD Sin filtrar
ax = axes[0]
ax.scatter(df["color"], df["Gmag"], s=8, alpha=0.5)
ax.set_xlabel("BP - RP")
ax.set_ylabel("Gmag")
ax.set_title("CMD (sin filtrar)")
ax.grid(alpha=0.3)
ax.set_ylim(7.5,21)
ax.invert_yaxis()

# --------------------
# Grafica 2, CMD Filtrado
ax = axes[1]
ax.scatter(datos_filtrados["color"], datos_filtrados["Gmag"], s=8, alpha=0.5)
ax.set_xlabel("BP - RP")
ax.set_ylabel("Gmag")
ax.set_title("CMD (filtrado cinemáticamente)")
ax.grid(alpha=0.3)
ax.set_ylim(7.5,21)
ax.invert_yaxis()

plt.tight_layout()
plt.show()
EOF

python3 3_analisis.py
