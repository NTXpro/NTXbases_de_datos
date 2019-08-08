CREATE PROC [ERP].[Usp_Upd_Transformacion_Anular_Por_Comprobante]
@P_IdComprobante INT
AS
BEGIN
		DECLARE @P_IdTransformacion AS INT
		DECLARE @P_FechaModificado AS DATETIME = getdate()
		DECLARE CursorAnulTranf CURSOR FOR 
				SELECT  t.ID AS IdTransformacion
				FROM ERP.ComprobanteDetalle cd  INNER JOIN ERP.Comprobante c ON cd.IdComprobante = c.ID
				LEFT JOIN ERP.Transformacion t ON c.SerieDocumentoComprobante = SUBSTRING(T.Observaciones, 1, 13)
				WHERE cd.IdProducto IN(SELECT r.IdProducto FROM ERP.Receta r) AND cd.IdComprobante = @P_IdComprobante;
					OPEN CursorAnulTranf
					FETCH NEXT FROM CursorAnulTranf INTO @P_IdTransformacion
						WHILE @@fetch_status = 0
						 BEGIN
							 EXEC [ERP].[Usp_Upd_Transformacion_Anular]	@ID = @P_IdTransformacion,@UsuarioModifico = 'NTXPRO',	@FechaModificado = @P_FechaModificado
							FETCH NEXT FROM CursorAnulTranf INTO  @P_IdTransformacion
						 END
				   CLOSE CursorAnulTranf
		DEALLOCATE CursorAnulTranf
END