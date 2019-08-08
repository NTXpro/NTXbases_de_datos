
CREATE PROC [ERP].[Usp_Sel_Compra_Inactivo]
@IdPeriodo INT,
@IdEmpresa INT
AS
BEGIN

		SELECT	CO.ID,
				TD.Abreviatura		TipoDocumento,
				ENT.Nombre			NombreProveedor,
				ETD.NumeroDocumento  RUC,
				TD.Nombre AS NombreTipoDocumento
		FROM ERP.Compra CO 
		INNER JOIN ERP.Empresa EM 
		ON EM.ID = CO.IdEmpresa
		INNER JOIN ERP.Periodo PE
		ON PE.ID = CO.IdPeriodo
		INNER JOIN ERP.Proveedor PRO
		ON PRO.ID = CO.IdProveedor
		INNER JOIN ERP.Entidad ENT
		ON ENT.ID = PRO.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = ENT.ID
		INNER JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
		WHERE CO.FlagBorrador = 0 AND CO.IdEmpresa = @IdEmpresa AND CO.Flag = 0 AND CO.IdPeriodo = @IdPeriodo
END
