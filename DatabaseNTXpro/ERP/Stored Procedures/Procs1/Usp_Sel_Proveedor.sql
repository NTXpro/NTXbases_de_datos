
CREATE PROC [ERP].[Usp_Sel_Proveedor] 
@IdEmpresa INT
AS
BEGIN
	SELECT P.ID,
		   P.IdEntidad,
		   E.Nombre,
		   ETD.NumeroDocumento,
		   ETD.IdTipoDocumento,
		   TD.Abreviatura TipoDocumento
	FROM ERP.Proveedor P
	INNER JOIN ERP.Entidad E ON E.ID = P.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = P.IdEntidad
	INNER JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento
	WHERE P.IdEmpresa = @IdEmpresa AND P.FlagBorrador = 0 AND P.Flag = 1
END

