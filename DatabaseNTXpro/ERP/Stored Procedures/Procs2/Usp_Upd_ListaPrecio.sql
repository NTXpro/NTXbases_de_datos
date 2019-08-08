
CREATE PROC [ERP].[Usp_Upd_ListaPrecio] --1,1,1,1,1,'',1
@IdListaPrecio INT,
@UsuarioModifico VARCHAR(250),
@IdMoneda INT,
@Nombre VARCHAR(50),
@PorcentajeDescuento INT,
@FlagBorrador BIT
AS
BEGIN
	
	UPDATE [ERP].[ListaPrecio] SET UsuarioModifico = @UsuarioModifico, 
								FechaModificado = DATEADD(HOUR, 3, GETDATE()),
								IdMoneda=@IdMoneda, 
								Nombre = @Nombre , 
								PorcentajeDescuento = @PorcentajeDescuento , 
								FlagBorrador = @FlagBorrador 
							
	WHERE ID = @IdListaPrecio 
END
