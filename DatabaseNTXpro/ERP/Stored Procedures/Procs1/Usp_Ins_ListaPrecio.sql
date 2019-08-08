
CREATE PROC [ERP].[Usp_Ins_ListaPrecio]
@IdListaPrecio INT OUT,
@IdMoneda  INT  ,
@IdEmpresa  INT  ,
@UsuarioRegistro VARCHAR(250),
@Nombre VARCHAR(50),
@PorcentajeDescuento INT ,
@FlagBorrador  BIT
AS
BEGIN

			INSERT INTO [ERP].[ListaPrecio] (Nombre,UsuarioRegistro,IdMoneda,IdEmpresa,PorcentajeDescuento,FechaRegistro,UsuarioModifico,FechaModificado,FlagBorrador,Flag)
									VALUES (@Nombre,@UsuarioRegistro,@IdMoneda,@IdEmpresa,@PorcentajeDescuento,DATEADD(HOUR, 3, GETDATE()),@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()),@FlagBorrador,1);
			
			SET @IdListaPrecio = (SELECT CAST(SCOPE_IDENTITY() AS int));

			INSERT INTO ERP.ListaPrecioDetalle(
			IdListaPrecio,
			IdProducto,
			PrecioUnitario,
			PorcentajeDescuento)
			SELECT  @IdListaPrecio,
					P.ID, 
					CAST(1 AS DECIMAL(14,5)),
					CAST(1 AS INT)
			FROM ERP.Producto  P
			WHERE FlagBorrador = 0 AND IdEmpresa = @IdEmpresa

END

