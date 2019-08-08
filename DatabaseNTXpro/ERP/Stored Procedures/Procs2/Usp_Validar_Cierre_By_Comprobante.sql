create PROC ERP.Usp_Validar_Cierre_By_Comprobante-- 11,2016,2,1
@IdComprobante INT,
@IdSistema INT,
@IdEmpresa INT
AS
BEGIN
	DECLARE @FECHA DATETIME = (SELECT Fecha FROM ERP.Comprobante WHERE ID = @IdComprobante)


	DECLARE @FlagCierre BIT = (SELECT FlagCierre
								FROM [ERP].[PeriodoSistema] PS
								INNER JOIN ERP.Periodo	P
									ON P.ID = PS.IdPeriodo
								INNER JOIN Maestro.Anio A
									ON A.ID = P.IdAnio
								INNER JOIN Maestro.Mes M
									ON M.ID = P.IdMes
								WHERE A.Nombre = YEAR(@FECHA) AND M.Valor = MONTH(@FECHA) AND PS.IdSistema = @IdSistema AND PS.IdEmpresa = @IdEmpresa)

	SELECT ISNULL(@FlagCierre,0)
END


--SELECT * FROM [ERP].[PeriodoSistema] PS
--SELECT * FROM ERP.PERIODO