CREATE PROC [ERP].[Usp_Ins_Existencia]
@IdExistencia	INT OUT,
@Nombre			VARCHAR(50),
@CodigoSunat	VARCHAR(2),
@UsuarioRegistro VARCHAR(250),
@FlagBorrador	BIT	,
@FlagSunat		BIT
AS
BEGIN
BEGIN TRAN
	BEGIN TRY;
			INSERT INTO [PLE].[T5Existencia](Nombre,CodigoSunat,FlagSunat,FlagBorrador,Flag, UsuarioRegistro,FechaRegistro,UsuarioModifico,FechaModificado)
										VALUES(@Nombre,@CodigoSunat,@FlagSunat,@FlagBorrador,1, @UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()), @UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()));
			SET @IdExistencia = (SELECT CAST(SCOPE_IDENTITY() AS INT));
			COMMIT TRAN
	END TRY

	BEGIN CATCH

		ROLLBACK TRAN

	END CATCH
END
