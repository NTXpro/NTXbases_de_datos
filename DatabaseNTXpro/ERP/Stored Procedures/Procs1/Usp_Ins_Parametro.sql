
CREATE PROC [ERP].[Usp_Ins_Parametro]
@IdParametro		INT OUT,
@IdPeriodo			INT,
@IdEmpresa			INT,
@IdTipoParametro	INT ,
@Nombre				VARCHAR(50),
@Abreviatura		VARCHAR(10),
@Valor				VARCHAR(20),
@UsuarioRegistro	VARCHAR(250)

AS
BEGIN
BEGIN TRAN
	BEGIN TRY;

			INSERT INTO [ERP].[Parametro](Nombre,IdPeriodo,IdEmpresa,Abreviatura,Valor,IdTipoParametro,FechaRegistro,Flag,UsuarioRegistro,UsuarioModifico,FechaModificado)VALUES (@Nombre,@IdPeriodo,@IdEmpresa,@Abreviatura,@Valor,@IdTipoParametro,DATEADD(HOUR, 3, GETDATE()),1,@UsuarioRegistro,@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()));
			SET @IdParametro = (SELECT CAST(SCOPE_IDENTITY() AS int));
		COMMIT TRAN
	END TRY
	BEGIN CATCH 
			ROLLBACK TRAN
	END CATCH
END
