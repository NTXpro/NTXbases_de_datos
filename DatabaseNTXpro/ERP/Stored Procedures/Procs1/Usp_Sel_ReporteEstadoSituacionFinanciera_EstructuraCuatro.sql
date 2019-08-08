﻿CREATE PROCEDURE [ERP].[Usp_Sel_ReporteEstadoSituacionFinanciera_EstructuraCuatro] --4,8,1,10,1,224
@IdEmpresa INT,
@IdAnio INT,
@IdMesDesde INT,
@IdMesHasta INT,
@IdMoneda INT,
@IdEstructuraTres INT
AS
BEGIN

	BEGIN -- DECLARACIONES

		DECLARE @DataInvalida TABLE(ID INT PRIMARY KEY NOT NULL);
		DECLARE @MES_DESDE INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesDesde);
		DECLARE @MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesHasta);
		DECLARE @IdGrado INT = (SELECT ID FROM Maestro.Grado WHERE 
								Longitud = (SELECT TOP 1 MAX(Longitud) FROM Maestro.Grado WHERE IdEmpresa = @IdEmpresa AND IdAnio = @IdAnio) AND 
								IdEmpresa = @IdEmpresa AND IdAnio = @IdAnio);
		SET @MES_DESDE = CASE WHEN @MES_DESDE = 1 THEN 0 ELSE @MES_DESDE END;

	END

	BEGIN -- ASIENTOS INVALIDOS

		INSERT INTO @DataInvalida
		SELECT 
		A.ID AS ID
		FROM ERP.AsientoDetalle AD
		INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
		INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
		INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
		INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
		INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
		WHERE 
		P.IdAnio = @IdAnio AND
		M.Valor BETWEEN @MES_DESDE AND @MES_HASTA AND
		A.IdEmpresa = @IdEmpresa AND
		O.Abreviatura NOT IN ('02','03')
		GROUP BY A.ID
		HAVING
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
		UNION
		SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	END

	BEGIN -- RESULTADO FINAL
		
		SELECT
			Temp.NivelDos,
			Temp.IdEstructuraTres,
			Temp.IdEstructuraCuatro,
			Temp.IdPlanCuenta,
			Temp.CuentaContable,
			Temp.Nombre,
			Temp.Operador,
			SUM(CASE
					WHEN Temp.NivelDos = 3 THEN (Temp.Total * -1)
					WHEN Temp.NivelDos = 4 THEN (Temp.Total * -1)
					WHEN Temp.NivelDos = 5 THEN (Temp.Total * -1)					
					ELSE Temp.Total
				END) AS Total
		FROM
		(SELECT
			T.NivelDos,
			EBGT.ID AS IdEstructuraTres,
			EBGC.ID AS IdEstructuraCuatro,
			PCP.ID AS IdPlanCuenta,
			PCP.CuentaContable,
			CONCAT(PCP.CuentaContable, ' - ', PCP.Nombre) AS Nombre,
			EBGC.Operador,
			CASE 
				WHEN @IdMoneda = 1 THEN
					CASE
						WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) < 0 THEN
							CASE
								WHEN EBGC.Operador = 1 THEN 0
								WHEN EBGC.Operador IS NULL THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END), 0)
								ELSE ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END), 0)
							END
						WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) > 0 THEN
							CASE
								WHEN EBGC.Operador IS NULL THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END), 0) - ISNULL(SUM(CASE CAST(AD.IdDebeHaber AS DECIMAL(14,2)) WHEN 2 THEN AD.ImporteSoles END), 0)
								WHEN EBGC.Operador = 2 THEN 0
								ELSE ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END), 0)
							END
						ELSE 0
					END
				WHEN @IdMoneda = 2 THEN
					CASE
						WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0) < 0 THEN
							CASE 
								WHEN EBGC.Operador = 1 THEN 0
								WHEN EBGC.Operador IS NULL THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END), 0)
								ELSE ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END), 0)
							END
						WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0) > 0 THEN
							CASE								
								WHEN EBGC.Operador IS NULL THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END), 0)
								WHEN EBGC.Operador = 2 THEN 0
								ELSE ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END), 0)
							END
						ELSE 0
					END
			END AS Total
		FROM
		ERP.EstructuraTres EBGT
		INNER JOIN ERP.EstructuraCuatro EBGC ON EBGT.ID = EBGC.IdEstructuraTres
		INNER JOIN ERP.EstructuraDos EBGD ON EBGT.IdEstructuraDos = EBGD.ID
		INNER JOIN ERP.EstructuraUno EBGU ON EBGD.IdEstructuraUno = EBGU.ID
		INNER JOIN ERP.PlanCuenta PCP ON EBGC.CuentaContable = PCP.CuentaContable AND PCP.IdEmpresa = @IdEmpresa AND PCP.IdAnio = @IdAnio
		-----
		INNER JOIN ERP.PlanCuenta PC ON PC.CuentaContable LIKE EBGC.CuentaContable + '%' AND PC.IdEmpresa = @IdEmpresa AND PC.IdAnio = @IdAnio AND PC.IdGrado = @IdGrado
		INNER JOIN ERP.AsientoDetalle AD ON PC.ID = AD.IdPlanCuenta
		-----
		INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
		INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
		INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
		----------------- CORRECCION DE NIVEL2 IDENTIFICADORES ---------------------
		INNER JOIN (SELECT
					ROW_NUMBER() OVER(ORDER BY ED.ID ASC) AS NivelDos,
					ED.ID 
					FROM ERP.EstructuraUno EU
					INNER JOIN ERP.EstructuraDos ED ON EU.ID = ED.IdEstructuraUno
					WHERE EU.IdEmpresa = @IdEmpresa AND EU.Tipo = 1) T ON EBGD.ID = T.ID
		----------------------------------------------------------------------------
		WHERE 
		EBGC.Flag = 1 AND 
		EBGT.Flag = 1 AND 
		EBGD.Flag = 1 AND 
		EBGU.Flag = 1 AND	
		EBGU.IdEmpresa = @IdEmpresa AND
		P.IdAnio = @IdAnio AND
		M.Valor BETWEEN @MES_DESDE AND @MES_HASTA AND
		A.IdEmpresa = @IdEmpresa AND		
		A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
		ISNULL(A.FlagBorrador, 0) = 0 AND
		A.Flag = 1 AND
		EBGU.Tipo = 1 AND
		EBGT.ID = @IdEstructuraTres
		GROUP BY
		T.NivelDos,
		EBGT.ID,
		EBGC.ID,
		EBGC.Operador,
		PCP.ID,
		PCP.CuentaContable,
		PCP.Nombre,
		PC.CuentaContable) Temp
		GROUP BY
		Temp.NivelDos,
		Temp.IdEstructuraTres,
		Temp.IdEstructuraCuatro,
		Temp.IdPlanCuenta,
		Temp.CuentaContable,
		Temp.Nombre,
		Temp.Operador
		HAVING
		SUM(CASE
			WHEN Temp.NivelDos = 3 THEN (Temp.Total * -1)
			WHEN Temp.NivelDos = 4 THEN (Temp.Total * -1)
			WHEN Temp.NivelDos = 5 THEN (Temp.Total * -1)
			ELSE Temp.Total
		END) <> 0
		ORDER BY Temp.CuentaContable
	END

END