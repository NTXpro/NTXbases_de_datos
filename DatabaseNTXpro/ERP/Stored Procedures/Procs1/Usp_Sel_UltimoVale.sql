CREATE PROC ERP.Usp_Sel_UltimoVale
@IdEmpresa INT,
@IdTipoMovimiento INT,
@Fecha DATETIME
AS
BEGIN
	SELECT ID,
		   Documento,
		   Flag
	FROM ERP.Vale WHERE IdEmpresa = @IdEmpresa AND MONTH(Fecha) = MONTH(@Fecha) AND YEAR(Fecha) = YEAR(@Fecha) AND IdTipoMovimiento = @IdTipoMovimiento
	AND Documento = (SELECT MAX(VU.Documento) FROM ERP.Vale VU WHERE VU.IdEmpresa = @IdEmpresa AND MONTH(VU.Fecha) = MONTH(@Fecha) AND YEAR(VU.Fecha) = YEAR(@Fecha) AND VU.IdTipoMovimiento = @IdTipoMovimiento)

END
