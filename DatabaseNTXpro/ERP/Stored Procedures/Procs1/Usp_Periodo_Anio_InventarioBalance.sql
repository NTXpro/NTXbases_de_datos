﻿CREATE PROC [ERP].[Usp_Periodo_Anio_InventarioBalance]

AS
BEGIN
	

SELECT DISTINCT
M.ID,
M.NOMBRE
FROM ERP.Asiento A

INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
INNER JOIN MAESTRO.Anio M ON P.IdAnio = M.ID
WHERE A.Flag = 1 AND A.FlagBorrador = 0
ORDER BY M.NOMBRE
END