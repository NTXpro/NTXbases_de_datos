create procedure ERP.Usp_Sel_Puesto_Export

@IdUnidadMedida		INT OUT,
@Nombre				VARCHAR(50),
@CodigoSunat		VARCHAR(3),
@UsuarioRegistro	VARCHAR(250),
@FlagBorrador		BIT
AS
BEGIN
BEGIN TRAN
	BEGIN TRY

			INSERT INTO [PLE].[T6UnidadMedida](Nombre,CodigoSunat,FlagSunat,FlagBorrador,Flag,UsuarioRegistro,FechaRegistro,UsuarioModifico,FechaModificado)
			VALUES(@Nombre, @CodigoSunat, 0, @FlagBorrador, 1, @UsuarioRegistro, DATEADD(HOUR, 3, GETDATE()), @UsuarioRegistro, DATEADD(HOUR, 3, GETDATE()));

			SET @IdUnidadMedida = (SELECT CAST(SCOPE_IDENTITY()AS INT));
	COMMIT TRAN
	END TRY

BEGIN CATCH
	ROLLBACK TRAN
END CATCH
END