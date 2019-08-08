CREATE PROC [ERP].[Usp_Ins_Almacen]
@IdAlmacen INT OUT,
@IdEmpresa INT,
@IdEstablecimiento INT,
@Nombre	VARCHAR(50),
@FlagBorrador BIT,
@UsuarioRegistro	VARCHAR(250)
AS
BEGIN

	INSERT INTO ERP.Almacen (IdEmpresa,IdEstablecimiento,Nombre,UsuarioRegistro,FechaRegistro, UsuarioModifico, FechaModificado,FlagBorrador,Flag)
	VALUES(@IdEmpresa,@IdEstablecimiento,@Nombre,@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()),@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()),@FlagBorrador,1)

	SET @IdAlmacen = (SELECT CAST(SCOPE_IDENTITY() AS INT));

END