	CREATE PROC [ERP].[Usp_Upd_MaestroDetraccion_Activar]
	@IdDetraccion INT,
	@UsuarioActivo VARCHAR(250)
	AS
	BEGIN

		UPDATE Maestro.Detraccion 
			SET Flag = 1,
				UsuarioActivo = @UsuarioActivo,
				FechaActivacion = DATEADD(HOUR, 3, GETDATE())
		WHERE ID = @IdDetraccion
	END