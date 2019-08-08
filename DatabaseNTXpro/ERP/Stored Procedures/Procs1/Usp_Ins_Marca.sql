
CREATE PROC [ERP].[Usp_Ins_Marca]
@IdMarca		INT OUT,
@Nombre			VARCHAR(50),
@UsuarioRegistro VARCHAR(250),
@FlagBorrador	BIT
AS
BEGIN
BEGIN TRAN
	BEGIN TRY
		INSERT INTO [Maestro].[Marca](Nombre, UsuarioRegistro, FlagBorrador, Flag, FechaRegistro,UsuarioModifico,FechaModificado)
							VALUES (@Nombre, @UsuarioRegistro,  @FlagBorrador, 1, DATEADD(HOUR, 3, GETDATE()),@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()) )
		SET @IdMarca = (SELECT CAST(SCOPE_IDENTITY() AS INT));
	COMMIT TRAN
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN
	END CATCH
END

