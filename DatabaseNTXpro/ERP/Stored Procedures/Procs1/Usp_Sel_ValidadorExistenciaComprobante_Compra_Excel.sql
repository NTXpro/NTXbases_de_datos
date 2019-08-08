CREATE PROC [ERP].[Usp_Sel_ValidadorExistenciaComprobante_Compra_Excel] 
	@IdTipoComprobante INT
	,@Serie VARCHAR(MAX)
	,@numero VARCHAR(MAX)
	,@IdEmpresa INT
AS

		SELECT COUNT(C.ID) AS RESULTADO
		FROM ERP.COMPRA C
		INNER JOIN ERP.Cliente c2 ON c2.IdEntidad = c.IdProveedor
		INNER JOIN ERP.Entidad e ON e.Id = c2.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento etd ON etd.IdEntidad = e.id
		INNER JOIN PLE.T2TipoDocumento td ON c.IdTipoComprobante = td.ID
		WHERE 
		
			 td.CodigoSunat = @IdTipoComprobante
			AND c.Serie = @Serie
			AND c.numero = @numero
			AND c.IdEmpresa = @IdEmpresa
		
