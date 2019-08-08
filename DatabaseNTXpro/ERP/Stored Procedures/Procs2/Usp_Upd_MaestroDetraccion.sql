
	CREATE PROC [ERP].[Usp_Upd_MaestroDetraccion]
	@IdDetraccion INT,
	@Nombre VARCHAR(50),
	@CodigoSunat VARCHAR(3),
	@Porcentaje DECIMAL(14,5),
	@UsuarioModifico VARCHAR(250),
	@FlagBorrador  BIT
	AS
	BEGIN
		UPDATE Maestro.Detraccion 
			SET Nombre = @Nombre,
				CodigoSunat=@CodigoSunat,
				Porcentaje=@Porcentaje,
				UsuarioModifico = @UsuarioModifico,
				FechaModificado = DATEADD(HOUR, 3, GETDATE()),
				FlagBorrador = @FlagBorrador
		WHERE ID = @IdDetraccion
	END