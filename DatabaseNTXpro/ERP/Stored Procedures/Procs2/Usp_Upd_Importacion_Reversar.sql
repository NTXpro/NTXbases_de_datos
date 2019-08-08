CREATE PROC [ERP].[Usp_Upd_Importacion_Reversar]
@ID INT,
@UsuarioModifico VARCHAR(250),
@FechaModificado DATETIME
AS
BEGIN
	DECLARE @ID_VALE AS INT = (SELECT IdVale FROM [ERP].[Importacion] WHERE ID = @ID);
	
	UPDATE [ERP].[Vale] SET
	[IdValeEstado] = (SELECT TOP 1 ID FROM Maestro.ValeEstado WHERE Abreviatura = 'R')
	WHERE [ID] = @ID_VALE;
	
	UPDATE [ERP].[Importacion] SET 
	[IdImportacionEstado] = (SELECT TOP 1 ID FROM Maestro.ImportacionEstado WHERE Abreviatura = 'R'),
	[UsuarioModifico] = @UsuarioModifico,
	[FechaModificado] = @FechaModificado
	WHERE [ID] = @ID;
END
