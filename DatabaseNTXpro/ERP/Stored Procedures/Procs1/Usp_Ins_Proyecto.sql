CREATE PROC [ERP].[Usp_Ins_Proyecto]
@IdProyecto INT OUT,
@IdEmpresa  INT  ,
@Nombre VARCHAR(50) ,
@Numero VARCHAR(50)  ,
@FechaInicio DateTime ,
@FlagBorrador  BIT,
@FlagCierre BIT,
@IdCliente INT,
@PresupuestoVenta DECIMAL(14, 5),
@PresupuestoCompra DECIMAL(14, 5),
@IdMoneda INT,
@UsuarioRegistro	VARCHAR(250),
@IdTipoProyecto int,
@IdProyectoPrincipal int

AS
BEGIN
	INSERT INTO [ERP].[Proyecto] 
		(
			IdEmpresa,
			Nombre,
			Numero,
			UsuarioRegistro,
			FechaInicio,
			FechaRegistro,
			FlagBorrador,
			FlagCierre,
			Flag,
			IdCliente,
			PresupuestoVenta,
			PresupuestoCompra,
			IdMoneda,
			IdTipoProyecto,
			IdProyectoPrincipal
		
		

		)
	VALUES 
		(
			@IdEmpresa,
			@Nombre,
			@Numero,
			@UsuarioRegistro,
			@FechaInicio,
			DATEADD(HOUR, 3, GETDATE()), 
			@FlagBorrador,
			@FlagCierre,
			1,
			@IdCliente,
			@PresupuestoVenta,
			@PresupuestoCompra,
			@IdMoneda,
			@IdTipoProyecto,
			@IdProyectoPrincipal
		
		
		);

	SET @IdProyecto = (SELECT CAST(SCOPE_IDENTITY() AS INT));
END