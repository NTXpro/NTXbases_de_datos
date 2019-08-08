	CREATE PROC ERP.Usp_Upd_MaestroDetraccion_Desactivar
	@IdDetraccion INT,
	@UsuarioElimino VARCHAR(250)
	AS
	BEGIN

		UPDATE Maestro.Detraccion 
			SET Flag = 0,
				UsuarioElimino = @UsuarioElimino,
				FechaEliminado = DATEADD(HOUR, 3, GETDATE())
		WHERE ID = @IdDetraccion

	END