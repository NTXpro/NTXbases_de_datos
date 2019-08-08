CREATE PROC [ERP].[Usp_Sel_DocumentoPagarDetalle_By_Proveedor_FechaEmision]
@IdProveedor INT,
@IdEmpresa INT,
@ListaTipoComprobante VARCHAR(MAX),
@FechaEmision DATETIME

AS 

BEGIN

SELECT A.ID,  A.Serie,A.Numero, A.Nombre, A.CodigoSunat,A.Total,
A.FechaEmision, A.FechaVencimiento,A.TipoComprobante
,A.TipoCambio
,A.SaldoSoles
,A.SaldoDolares
 FROM (
SELECT CP.ID,
				CP.Serie,
				CP.Numero,
				ENT.Nombre,
			--	CP.IdMoneda ,
				MO.CodigoSunat,
				CASE
					WHEN TC.CodigoSunat = '07' OR TC.CodigoSunat = '87' THEN CP.Total * -1
					ELSE CP.Total
				END Total,
				CP.Fecha FechaEmision,
				CP.FechaVencimiento FechaVencimiento,
				TC.Nombre TipoComprobante,
				CP.TipoCambio,	
				CASE
					 WHEN CP.IdMoneda = 1 THEN
						CASE
							WHEN TC.CodigoSunat = '07' OR TC.CodigoSunat = '87' THEN 
							   (SELECT (ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID, CAST(@FechaEmision AS DateTime)))) * -1
							ELSE 
							   (SELECT(ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID, CAST(@FechaEmision AS DateTime)))) 
							 END
					 ELSE 0 
			     END SaldoSoles,
				CASE
					WHEN CP.IdMoneda = 2 THEN
						CASE
							WHEN TC.CodigoSunat = '07' OR TC.CodigoSunat = '87' THEN (SELECT (ERP.SaldoTotalCuentaPagarDeDolaresPorFecha(CP.ID, CAST(@FechaEmision AS DateTime)))) * -1
							ELSE (SELECT TOP 1(ERP.SaldoTotalCuentaPagarDeDolaresPorFecha(CP.ID, CAST(@FechaEmision AS DateTime)))) END
					ELSE 0 END SaldoDolares,

					ISNULL(CASE 
					WHEN CP.IdMoneda = 1 THEN
					  ISNULL((SELECT(ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID,@FechaEmision))), 0) 
					ELSE 
					  ISNULL((SELECT (ERP.SaldoTotalCuentaPagarDeSolesPorFecha(CP.ID,@FechaEmision))),0)
					END, 0) AS CampoX
		FROM ERP.CuentaPagar CP
		INNER JOIN Maestro.Moneda MO
		ON MO.ID = CP.IdMoneda
		INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = CP.IdTipoComprobante
		INNER JOIN ERP.Entidad ENT
		ON ENT.ID = CP.IdEntidad
		INNER JOIN ERP.Proveedor PRO
	    ON PRO.IdEntidad = ENT.ID
		WHERE CP.Flag = 1 AND PRO.ID = @IdProveedor AND CP.IdEmpresa = @IdEmpresa
		AND CP.IdTipoComprobante IN (SELECT  DATA FROM [ERP].[Fn_SplitContenido] (@ListaTipoComprobante,','))
		AND CAST(CP.Fecha AS DATE) <= CAST(@FechaEmision AS DATE))  AS A
		WHERE A.CampoX <>0
		AND (A.SaldoSoles <>0 OR A.SaldoDolares<>0)
END