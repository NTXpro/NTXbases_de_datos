
CREATE PROC [ERP].[Usp_Upd_Servicio] 
@IdProducto INT,
@IdPlanCuenta INT,
@Nombre  VARCHAR(50),
@FlagBorrador BIT,
@CodigoReferencia VARCHAR(50),
@UsuarioModifico	VARCHAR(250),
@FlagISC BIT,
@FlagIGVAfecto BIT
AS
BEGIN
	
	UPDATE [ERP].[Producto] SET 
								Nombre = @Nombre ,
								FlagBorrador = @FlagBorrador ,
								IdPlanCuenta=@IdPlanCuenta,
								CodigoReferencia = @CodigoReferencia,
								UsuarioModifico=@UsuarioModifico,
								FechaModificado=DATEADD(HOUR, 3, GETDATE()),
								FlagISC=@FlagISC,
								FlagIGVAfecto=@FlagIGVAfecto
	WHERE ID = @IdProducto  AND IdTipoProducto = 2
END
