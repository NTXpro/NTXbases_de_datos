CREATE PROC [ERP].[Usp_Sel_OrdenPago_By_ID]
@ID INT
AS
BEGIN
	SELECT OP.ID
		,OP.Serie
		,OP.Documento
		,OP.IdProyecto
		,P.Nombre NombreProyecto
		,OP.IdEntidad
		,ETD.IdTipoDocumento
		,ETD.NumeroDocumento
		,E.Nombre NombreEntidad
		,OP.IdMoneda
		,M.Nombre NombreMoneda
		,OP.IdEmpresa
		,OP.Fecha
		,UPPER(OP.Descripcion) Descripcion
		,OP.TipoCambio
		,OP.Total
		,OP.UsuarioRegistro
		,OP.UsuarioModifico
		,OP.FechaRegistro
		,OP.FechaModificado
		,OP.Flag
	FROM ERP.OrdenPago OP 
	LEFT JOIN ERP.Entidad E ON E.ID = OP.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID 
	LEFT JOIN ERP.Proyecto P ON P.ID = OP.IdProyecto
	LEFT JOIN Maestro.Moneda M ON M.ID = OP.IdMoneda
	WHERE OP.ID = @ID

END