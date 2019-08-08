CREATE PROC ERP.Usp_Validar_Cierre_Sistema-- 11,2016,2,1
@Mes INT,
@Anio INT,
@IdSistema INT,
@IdEmpresa INT
AS
BEGIN

	DECLARE @FlagCierre BIT = (SELECT FlagCierre
								FROM [ERP].[PeriodoSistema] PS
								INNER JOIN ERP.Periodo	P
									ON P.ID = PS.IdPeriodo
								INNER JOIN Maestro.Anio A
									ON A.ID = P.IdAnio
								INNER JOIN Maestro.Mes M
									ON M.ID = P.IdMes
								WHERE A.Nombre = @Anio AND M.Valor = @Mes AND PS.IdSistema = @IdSistema AND PS.IdEmpresa = @IdEmpresa)

	SELECT ISNULL(@FlagCierre,0)
END


--SELECT * FROM [ERP].[PeriodoSistema] PS
--SELECT * FROM ERP.PERIODO