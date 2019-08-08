
CREATE PROC [ERP].[Usp_Sel_Entidad]
@IdEmpresa INT
AS
BEGIN
	SELECT	E.ID,
			E.Nombre,
			ETD.NumeroDocumento,
			CLI.ID IdCliente,
			P.ID IdProveedor,
			TD.Abreviatura NombreTipoDocumento
	FROM ERP.Entidad E
	INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
	INNER JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento
	LEFT JOIN ERP.Cliente CLI ON CLI.IdEntidad = E.ID AND CLI.Flag = 1 AND CLI.FlagBorrador = 0 AND CLI.IdEmpresa = @IdEmpresa
	LEFT JOIN ERP.Proveedor P ON P.IdEntidad = E.ID AND P.Flag = 1 AND P.FlagBorrador = 0 AND P.IdEmpresa = @IdEmpresa
	WHERE E.Flag = 1 AND E.FlagBorrador = 0
END
