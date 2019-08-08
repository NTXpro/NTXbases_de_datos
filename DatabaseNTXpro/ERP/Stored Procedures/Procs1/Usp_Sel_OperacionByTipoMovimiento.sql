CREATE PROC [ERP].[Usp_Sel_OperacionByTipoMovimiento]  --2
@IdTipoMovimiento INT,
@Anio INT,
@IdEmpresa INT
AS
BEGIN
	declare @IdAnio INT=(SELECT ID FROM Maestro.Anio WHERE Nombre = @Anio)
	
	SELECT	OP.ID,
			OP.Nombre Operacion,
			OP.IdTipoMovimiento,
			OP.IdPlanCuenta,
			OP.IdEmpresa,
			TM.Nombre
	FROM ERP.Operacion OP
	INNER JOIN Maestro.TipoMovimiento TM
	ON TM.ID = OP.IdTipoMovimiento
	INNER JOIN ERP.Empresa EM
	ON EM.ID = OP.IdEmpresa
	WHERE OP.IdTipoMovimiento = @IdTipoMovimiento AND OP.IdEmpresa = @IdEmpresa AND OP.IdAnio = @IdAnio
	ORDER BY OP.Nombre ASC
END