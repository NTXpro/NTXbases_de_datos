CREATE PROC [ERP].[Usp_Ins_Rol] 
@IdRol INT OUT,
@Nombre VARCHAR(50),
@FlagBorrador  BIT,
@UsuarioRegistro	VARCHAR(250)

AS
BEGIN
	BEGIN TRAN
		BEGIN TRY;

			INSERT INTO [Seguridad].[Rol](Nombre,FechaRegistro,FlagBorrador,Flag,UsuarioRegistro,UsuarioModifico,FechaModificado)VALUES (@Nombre,DATEADD(HOUR, 3, GETDATE()),@FlagBorrador,1,@UsuarioRegistro,@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()));
			SET @IdRol = (SELECT CAST(SCOPE_IDENTITY() AS int));
		COMMIT TRAN
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN
	END CATCH
END
