CREATE PROC [ERP].[Usp_Sel_Compra_Borrador] --88,1
@IdEmpresa INT,
@IdPeriodo INT
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
		LEFT JOIN ERP.Proveedor PRO
		ON PRO.ID = CO.IdProveedor
		LEFT JOIN ERP.Entidad ENT
		ON ENT.ID = PRO.IdEntidad
		LEFT JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = ENT.ID
		LEFT JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
		WHERE CO.FlagBorrador = 1 AND CO.IdEmpresa = @IdEmpresa AND CO.IdPeriodo = @IdPeriodo
END
