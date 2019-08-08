CREATE PROC [ERP].[Usp_Upd_Transformacion_Anular]
@ID INT,
@UsuarioModifico VARCHAR(250),
@FechaModificado DATETIME
AS
BEGIN
	DECLARE @ID_VALE_INGRESO AS INT = (SELECT TOP 1 IdValeIngreso FROM [ERP].[Transformacion] WHERE ID = @ID);
	DECLARE @ID_VALE_SALIDA AS INT = (SELECT TOP 1 IdValeSalida FROM [ERP].[Transformacion] WHERE ID = @ID);
	
	UPDATE [ERP].[Vale] SET
	[IdValeEstado] = (SELECT TOP 1 ID FROM Maestro.ValeEstado WHERE Abreviatura = 'A')
	WHERE [ID] = @ID_VALE_INGRESO;

	UPDATE [ERP].[Vale] SET
	[IdValeEstado] = (SELECT TOP 1 ID FROM Maestro.ValeEstado WHERE Abreviatura = 'A')
	WHERE [ID] = @ID_VALE_SALIDA;
	
	UPDATE [ERP].[Transformacion] SET 
	[IdTransformacionEstado] = (SELECT TOP 1 ID FROM [Maestro].[TransformacionEstado] WHERE Abreviatura = 'A'),
	[UsuarioModifico] = @UsuarioModifico,
	[FechaModificado] = @FechaModificado
	WHERE [ID] = @ID;
END
