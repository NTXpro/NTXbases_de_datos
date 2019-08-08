CREATE PROCEDURE ERP.Sel_ComprobanteRetencion_By_ID
@ID INT
AS
	SELECT	CR.ID,
			CR.IdEmpresa,
			CR.IdCliente,
			EN.Nombre NombreCliente, 
			ETD.NumeroDocumento NroDocumentoCliente,
			CR.Serie,
			CR.Documento,
			CR.FechaEmision,
			CR.TipoCambio,
			CR.ImportePago,
			CR.ImporteRetenido,
			CR.FlagBorrador,
			CR.Flag,
			CR.UsuarioRegistro,
			CR.FechaRegistro,
			CR.UsuarioModifico,
			CR.FechaModifico,
			CR.UsuarioAnulo,
			CR.FechaAnulo,
			CR.FlagEmitido
	FROM ERP.ComprobanteRetencion CR
	INNER JOIN ERP.Cliente C ON CR.IdCliente = C.ID
	INNER JOIN ERP.Entidad EN ON C.IdEntidad = EN.ID
	INNER JOIN ERP.EntidadTipoDocumento ETD ON EN.ID = ETD.IdEntidad
	INNER JOIN PLE.T2TipoDocumento T2 ON ETD.IdTipoDocumento = T2.ID
	WHERE CR.ID = @ID

