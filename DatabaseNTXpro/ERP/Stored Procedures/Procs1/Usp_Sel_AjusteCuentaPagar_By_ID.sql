
create PROC [ERP].[Usp_Sel_AjusteCuentaPagar_By_ID]
@ID INT
AS
BEGIN
	SELECT ACC.ID
	    ,ACC.Documento
        ,ACC.Fecha
        ,TC.Nombre NombreTipoComprobante
	    ,C.Serie
	    ,C.Numero
	    ,M.Nombre NombreMoneda
        ,ACC.Total
        ,ACC.TipoCambio
		,E.Nombre NombreEntidad
		,ACC.UsuarioRegistro
		,ACC.FechaRegistro
    FROM [ERP].[AjusteCuentaPagar] ACC
    INNER JOIN ERP.CuentaPagar C ON C.ID = ACC.IdCuentaPagar
	INNER JOIN ERP.Entidad E ON E.ID = ACC.IdEntidad
    INNER JOIN [PLE].[T10TipoComprobante] TC ON TC.ID = C.IdTipoComprobante
    INNER JOIN Maestro.Moneda M ON M.ID = ACC.IdMoneda
	WHERE ACC.ID = @ID
END
