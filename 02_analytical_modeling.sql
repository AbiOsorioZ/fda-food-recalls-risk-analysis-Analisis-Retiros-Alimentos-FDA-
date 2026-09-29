CREATE OR REPLACE TABLE `portafolio-genomica.fda_recalls_ds.recalls_dashboard_final` AS
SELECT
  -- Identifiers and auditing
  fei_number,
  clasificacion,
  estatus,
  fecha_clasificacion,
  anio,
  mes,
  empresa,
  estado,
  pais,
  patron_distribucion,

  -- 1. Categorized Root Cause
  CASE 
    WHEN LOWER(razon_retiro) LIKE '%listeria%' THEN 'Microbiológico: Listeria'
    WHEN LOWER(razon_retiro) LIKE '%salmonella%' THEN 'Microbiológico: Salmonella'
    WHEN LOWER(razon_retiro) LIKE '%coli%' THEN 'Microbiológico: E. Coli'
    WHEN LOWER(razon_retiro) LIKE '%botulin%' OR LOWER(razon_retiro) LIKE '%clostridium%' THEN 'Microbiológico: Clostridium / Botulismo'
    WHEN LOWER(razon_retiro) LIKE '%mold%' OR LOWER(razon_retiro) LIKE '%yeast%' THEN 'Microbiológico: Mohos / Levaduras'

    WHEN LOWER(razon_retiro) LIKE '%allergen%'
      OR LOWER(razon_retiro) LIKE '%undeclared%'
      OR LOWER(razon_retiro) LIKE '%peanut%'
      OR LOWER(razon_retiro) LIKE '%milk%'
      OR LOWER(razon_retiro) LIKE '%egg%'
      OR LOWER(razon_retiro) LIKE '%soy%'
      OR LOWER(razon_retiro) LIKE '%wheat%'
      OR LOWER(razon_retiro) LIKE '%nut%'
      OR LOWER(razon_retiro) LIKE '%sesame%'
      OR LOWER(razon_retiro) LIKE '%fish%'
      OR LOWER(razon_retiro) LIKE '%shellfish%' THEN 'Alérgenos no declarados'

    WHEN LOWER(razon_retiro) LIKE '%metal%'
      OR LOWER(razon_retiro) LIKE '%plastic%'
      OR LOWER(razon_retiro) LIKE '%glass%'
      OR LOWER(razon_retiro) LIKE '%foreign%' THEN 'Contaminación física'

    WHEN LOWER(razon_retiro) LIKE '%lead%'
      OR LOWER(razon_retiro) LIKE '%sulfite%'
      OR LOWER(razon_retiro) LIKE '%toxin%' THEN 'Contaminación química / Toxinas'

    ELSE 'Otras causas / Empaque y Proceso'
  END AS categoria_peligro,

  -- 2. Categorized Food Matrix
  CASE
    WHEN LOWER(descripcion_producto) LIKE '%chocolate%' 
      OR LOWER(descripcion_producto) LIKE '%candy%' 
      OR LOWER(descripcion_producto) LIKE '%cocoa%' THEN 'Chocolates y Confitería'

    WHEN LOWER(descripcion_producto) LIKE '%cheese%' 
      OR LOWER(descripcion_producto) LIKE '%milk%' 
      OR LOWER(descripcion_producto) LIKE '%cream%' 
      OR LOWER(descripcion_producto) LIKE '%yogurt%' 
      OR LOWER(descripcion_producto) LIKE '%butter%' THEN 'Lácteos y Derivados'

    WHEN LOWER(descripcion_producto) LIKE '%salad%' 
      OR LOWER(descripcion_producto) LIKE '%lettuce%' 
      OR LOWER(descripcion_producto) LIKE '%spinach%' 
      OR LOWER(descripcion_producto) LIKE '%sprout%' 
      OR LOWER(descripcion_producto) LIKE '%fruit%' 
      OR LOWER(descripcion_producto) LIKE '%apple%' 
      OR LOWER(descripcion_producto) LIKE '%berry%' 
      OR LOWER(descripcion_producto) LIKE '%onion%' THEN 'Vegetales, Ensaladas y Frutas'

    WHEN LOWER(descripcion_producto) LIKE '%bread%' 
      OR LOWER(descripcion_producto) LIKE '%cake%' 
      OR LOWER(descripcion_producto) LIKE '%cookie%' 
      OR LOWER(descripcion_producto) LIKE '%muffin%' 
      OR LOWER(descripcion_producto) LIKE '%pastry%' 
      OR LOWER(descripcion_producto) LIKE '%flour%' THEN 'Panadería y Galletería'

    WHEN LOWER(descripcion_producto) LIKE '%beef%' 
      OR LOWER(descripcion_producto) LIKE '%chicken%' 
      OR LOWER(descripcion_producto) LIKE '%pork%' 
      OR LOWER(descripcion_producto) LIKE '%sausage%' 
      OR LOWER(descripcion_producto) LIKE '%meat%' THEN 'Cárnicos y Aves'

    WHEN LOWER(descripcion_producto) LIKE '%fish%' 
      OR LOWER(descripcion_producto) LIKE '%salmon%' 
      OR LOWER(descripcion_producto) LIKE '%tuna%' 
      OR LOWER(descripcion_producto) LIKE '%shrimp%' 
      OR LOWER(descripcion_producto) LIKE '%seafood%' THEN 'Pescados y Mariscos'

    WHEN LOWER(descripcion_producto) LIKE '%peanut%' 
      OR LOWER(descripcion_producto) LIKE '%almond%' 
      OR LOWER(descripcion_producto) LIKE '%cashew%' 
      OR LOWER(descripcion_producto) LIKE '%walnut%' 
      OR LOWER(descripcion_producto) LIKE '%pistachio%' THEN 'Frutos Secos y Semillas'

    ELSE 'Otras Matrices / Procesados Diversos'
  END AS matriz_alimentaria,

  -- Bandera numérica para severidad (útil para promedios en Looker)
  IF(clasificacion = 'Class I', 1, 0) AS es_clase_1

FROM 
  `portafolio-genomica.fda_recalls_ds.recalls_food_clean`;