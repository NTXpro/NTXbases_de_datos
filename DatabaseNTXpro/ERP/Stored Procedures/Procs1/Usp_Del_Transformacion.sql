CREATE PROC [ERP].[Usp_Del_Transformacion]
@ID INT
AS
BEGIN
	DELETE FROM [ERP].[TransformacionOrigenDetalle] WHERE IdTransformacion = @ID
	DELETE FROM [ERP].[TransformacionMermaDetalle] WHERE IdTransformacion = @ID
	DELETE FROM [ERP].[TransformacionServicioDetalle] WHERE IdTransformacion = @ID
	DELETE FROM [ERP].[TransformacionDestinoDetalle] WHERE IdTransformacion = @ID
	DELETE FROM [ERP].[Transformacion] WHERE ID = @ID
END
