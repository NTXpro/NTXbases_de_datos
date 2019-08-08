CREATE PROC [ERP].[Usp_Ins_Talonario]
@IdTalonario INT OUT,
@IdEmpresa INT,
@IdCuenta INT,
@Inicio INT,
@Fin INT,
@FlagBorrador BIT,
@UsuarioRegistro VARCHAR(250)
AS
BEGIN
	
	INSERT INTO ERP.Talonario (IdCuenta,IdEmpresa,Inicio,Fin,UsuarioRegistro,FlagBorrador,Flag,FechaRegistro,UsuarioModifico,FechaModificado)
	VALUES(@IdCuenta,@IdEmpresa,@Inicio,@Fin,@UsuarioRegistro,@FlagBorrador,CAST(1 AS BIT),DATEADD(HOUR,3,GETDATE()),@UsuarioRegistro,DATEADD(HOUR,3,GETDATE()))
	SET @IdTalonario = (SELECT SCOPE_IDENTITY())
END
