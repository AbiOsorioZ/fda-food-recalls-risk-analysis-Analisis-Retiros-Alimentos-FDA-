CREATE OR REPLACE TABLE `portafolio-genomica.fda_recalls_ds.recalls_food_clean` AS
SELECT
  -- Identifiers and classification
  `FEI Number` AS fei_number,
  `Product Classification` AS clasificacion,
  `Status` AS estatus,
  
  -- Conversion of nanoseconds to DATE
  DATE(SAFE.TIMESTAMP_MICROS(DIV(`Center Classification Date`, 1000))) AS fecha_clasificacion,
  EXTRACT(YEAR FROM DATE(SAFE.TIMESTAMP_MICROS(DIV(`Center Classification Date`, 1000)))) AS anio,
  EXTRACT(MONTH FROM DATE(SAFE.TIMESTAMP_MICROS(DIV(`Center Classification Date`, 1000)))) AS mes,
  
  -- Location and company
  TRIM(`Recalling Firm Name`) AS empresa,
  `Recalling Firm State` AS estado,
  `Recalling Firm Country` AS pais,
  `Distribution Pattern` AS patron_distribucion,
  
  -- Key variables for root cause analysis
  TRIM(`Product Type`) AS tipo_producto,
  TRIM(`Reason for Recall`) AS razon_retiro,
  TRIM(`Product Description`) AS descripcion_producto

FROM 
  `portafolio-genomica.fda_recalls_ds.recalls_raw`
WHERE 
  `Product Type` = 'Food/Cosmetics'
  AND `Reason for Recall` IS NOT NULL
  AND `Center Classification Date` IS NOT NULL;