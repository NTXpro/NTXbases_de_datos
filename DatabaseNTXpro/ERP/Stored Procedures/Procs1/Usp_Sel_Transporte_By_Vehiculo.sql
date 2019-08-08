CREATE PROC [ERP].[Usp_Sel_Transporte_By_Vehiculo]
@IdVehiculo INT,
@IdEmpresa INT
AS
BEGIN
	SELECT TR.ID,
		   ENT.Nombre
	FROM ERP.Vehiculo VE
	INNER JOIN ERP.Transporte TR ON TR.ID = VE.IdEmpresaTransporte
	INNER JOIN ERP.Entidad ENT ON ENT.ID = TR.IdEntidad
	WHERE VE.ID = @IdVehiculo AND TR.IdEmpresa = @IdEmpresa AND TR.Flag = 1 AND TR.FlagBorrador = 0 
END
