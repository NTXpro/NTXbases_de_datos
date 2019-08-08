CREATE PROC [ERP].[Usp_Upd_Proyecto]
@IdProyecto INT,
@Nombre VARCHAR(50) ,
@Numero VARCHAR(50)  ,
@FechaInicio DateTime ,
@FlagBorrador  BIT,
@IdCliente INT,
@PresupuestoVenta DECIMAL(14, 5),
@PresupuestoCompra DECIMAL(14, 5),
@IdMoneda INT,
@UsuarioModifico VARCHAR(250),
@IdTipoProyecto int ,
@IdProyectoPrincipal int 

AS
BEGIN
	
	UPDATE [ERP].[Proyecto] 
	SET Nombre = @Nombre, 
		Numero = @Numero, 
		FechaInicio = @FechaInicio, 								
		FlagBorrador = @FlagBorrador,
		IdCliente = @IdCliente,
		PresupuestoVenta = @PresupuestoVenta,
		PresupuestoCompra = @PresupuestoCompra,
		IdMoneda = @IdMoneda,
		UsuarioModifico = @UsuarioModifico,		
		FechaModificado = DATEADD(HOUR, 3, GETDATE()),
		IdTipoProyecto=@IdTipoProyecto,
		IdProyectoPrincipal=@IdProyectoPrincipal
	
	WHERE ID = @IdProyecto 
END