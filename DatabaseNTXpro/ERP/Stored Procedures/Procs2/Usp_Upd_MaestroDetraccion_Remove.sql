	CREATE PROC ERP.Usp_Upd_MaestroDetraccion_Remove
	@IdDetraccion INT
	AS
	BEGIN

		DELETE Maestro.Detraccion
		WHERE ID = @IdDetraccion

	END