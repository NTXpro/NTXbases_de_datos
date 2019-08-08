

-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 16/10/2018
-- Description:	CREA TRANSFORMACIONES POR CADA PRODUCTO
--              TIPO RECETA EN COMPROBANTES
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Upd_TransformacionComprobante_Manual] 
	 @PARAM_IdComprobante INT 
AS
BEGIN
	
DECLARE @IDPRODUCTOFINAL INT
DECLARE @CANTPRODUCTOFINAL INT
DECLARE @HORATRABAJO DATETIME
DECLARE @IDPROYECTO INT
DECLARE @IGV DECIMAL(14,5)
DECLARE @IDMONEDA INT
DECLARE @USUARIO VARCHAR(250)
DECLARE @SerieDocumentoComprobante VARCHAR(40)

DECLARE ValeTransf CURSOR FOR SELECT cd.IdProducto, cd.Cantidad,c.Fecha,c.IdProyecto,c.IGV,c.IdMoneda,c.UsuarioRegistro, c.SerieDocumentoComprobante + ' - ' + convert(varchar, c.Fecha, 103) AS SerieBoleta  FROM ERP.Comprobante c
INNER JOIN ERP.ComprobanteDetalle cd ON c.ID = cd.IdComprobante WHERE c.ID  = @PARAM_IdComprobante 
OPEN ValeTransf
FETCH NEXT FROM ValeTransf INTO @IDPRODUCTOFINAL,@CANTPRODUCTOFINAL,@HORATRABAJO,@IDPROYECTO,@IGV,@IDMONEDA,@USUARIO,@SerieDocumentoComprobante
WHILE @@fetch_status = 0
BEGIN
    EXEC	[ERP].[Usp_Generador_Tranformacion_por_Receta_Comprobante_Manual]
		@PARAM_IDPRODUCTOFINAL = @IDPRODUCTOFINAL,
		@PARAM_CANTPRODUCTOFINAL = @CANTPRODUCTOFINAL,
		@PARAM_REFERENCIAVENTA = 'REFERENCIA AUTOGEN',
		@PARAM_USUARIO = @USUARIO,
		@PARAM_HORATRABAJO = @HORATRABAJO,
		@PARAM_IDPROYECTO = @IDPROYECTO,
		@PARAM_IGV = @IGV,
		@PARAM_IDMONEDA = @IDMONEDA,
		@PARAM_SerieDocumentoComprobante = @SerieDocumentoComprobante

    FETCH NEXT FROM ValeTransf INTO @IDPRODUCTOFINAL,@CANTPRODUCTOFINAL,@HORATRABAJO,@IDPROYECTO,@IGV,@IDMONEDA ,@USUARIO,@SerieDocumentoComprobante
END
CLOSE ValeTransf
DEALLOCATE ValeTransf
END