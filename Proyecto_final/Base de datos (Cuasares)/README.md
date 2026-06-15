# Bases de datos para el proyecto

Estas bases fueron consultadas en la pagina oficial de SDSS: https://skyserver.linea.org.br/sciserver/SearchTools/sql

Fueron 3 consultas diferentes ya que la página solo permite descargar bases de datos para un máximo de 500 mil datos, y contabamos con más de 700 mil cuásares, Los sql usados fueron:


  SELECT
    sp.objID,
    sp.ra,
    sp.dec,
    sp.z AS z_spec,
    sp.zErr,

    sp.psfMag_u,
    sp.psfMag_g,
    sp.psfMag_r,
    sp.psfMag_i,
    sp.psfMag_z,

    sp.psfMag_u - sp.psfMag_g AS ug,
    sp.psfMag_g - sp.psfMag_r AS gr,
    sp.psfMag_r - sp.psfMag_i AS ri,
    sp.psfMag_i - sp.psfMag_z AS iz

FROM SpecPhoto AS sp

WHERE sp.class = 'QSO'
  AND sp.zWarning = 0
  AND sp.psfMag_u IS NOT NULL
  AND sp.psfMag_g IS NOT NULL
  AND sp.psfMag_r IS NOT NULL
  AND sp.psfMag_i IS NOT NULL
  AND sp.psfMag_z IS NOT NULL
  AND z < 1.5

- Segundo sql:
  
  SELECT
    sp.objID,
    sp.ra,
    sp.dec,
    sp.z AS z_spec,
    sp.zErr,

    sp.psfMag_u,
    sp.psfMag_g,
    sp.psfMag_r,
    sp.psfMag_i,
    sp.psfMag_z,

    sp.psfMag_u - sp.psfMag_g AS ug,
    sp.psfMag_g - sp.psfMag_r AS gr,
    sp.psfMag_r - sp.psfMag_i AS ri,
    sp.psfMag_i - sp.psfMag_z AS iz

FROM SpecPhoto AS sp

WHERE sp.class = 'QSO'
  AND sp.zWarning = 0
  AND sp.psfMag_u IS NOT NULL
  AND sp.psfMag_g IS NOT NULL
  AND sp.psfMag_r IS NOT NULL
  AND sp.psfMag_i IS NOT NULL
  AND sp.psfMag_z IS NOT NULL
  AND z >= 1.5
  AND z < 2.5

- tercer sql
  
  SELECT
    sp.objID,
    sp.ra,
    sp.dec,
    sp.z AS z_spec,
    sp.zErr,

    sp.psfMag_u,
    sp.psfMag_g,
    sp.psfMag_r,
    sp.psfMag_i,
    sp.psfMag_z,

    sp.psfMag_u - sp.psfMag_g AS ug,
    sp.psfMag_g - sp.psfMag_r AS gr,
    sp.psfMag_r - sp.psfMag_i AS ri,
    sp.psfMag_i - sp.psfMag_z AS iz

FROM SpecPhoto AS sp

WHERE sp.class = 'QSO'
  AND sp.zWarning = 0
  AND sp.psfMag_u IS NOT NULL
  AND sp.psfMag_g IS NOT NULL
  AND sp.psfMag_r IS NOT NULL
  AND sp.psfMag_i IS NOT NULL
  AND sp.psfMag_z IS NOT NULL
  AND z >= 2.5
