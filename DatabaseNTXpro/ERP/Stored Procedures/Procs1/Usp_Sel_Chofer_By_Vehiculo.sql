CREATE PROC [ERP].[Usp_Sel_Chofer_By_Vehiculo]
@IdVehiculo INT,
@IdEmpresa INT
AS
BEGIN
	SELECT CH.ID,
		   ENT.Nombre
	FROM ERP.Vehiculo VE
	INNER JOIN ERP.Chofer CH ON CH.ID = VE.IdChofer
	INNER JOIN ERP.Entidad ENT ON ENT.ID = CH.IdEntidad
	WHERE VE.ID = @IdVehiculo AND CH.IdEmpresa = @IdEmpresa AND CH.Flag = 1 AND CH.FlagBorrador = 0 

END
