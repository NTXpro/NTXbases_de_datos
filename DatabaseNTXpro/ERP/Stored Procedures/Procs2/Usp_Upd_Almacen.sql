
CREATE PROC [ERP].[Usp_Upd_Almacen]
@IdAlmacen INT,
@IdEstablecimiento INT,
@Nombre	VARCHAR(50),
@FlagBorrador BIT,
@UsuarioModifico VARCHAR(250)
AS
BEGIN

	UPDATE ERP.Almacen SET Nombre = @Nombre, IdEstablecimiento = @IdEstablecimiento,FlagBorrador = @FlagBorrador,UsuarioModifico=@UsuarioModifico,FechaModificado=DATEADD(HOUR, 3, GETDATE())
	WHERE ID = @IdAlmacen

END