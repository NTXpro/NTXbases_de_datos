CREATE PROCEDURE ERP.Usp_Anul_ComprobanteRetencion
@ID INT,
@UsuarioAnulo VARCHAR(250)
AS
	DECLARE @IdCuentaCobrar INT,
			@IdAplicacionAnticipoCobrar INT,
			@IdAsiento INT

	UPDATE ERP.ComprobanteRetencion
	SET Flag = 0,
		FlagEmitido = 0,
		@IdCuentaCobrar = IdCuentaCobrar,
		UsuarioAnulo = @UsuarioAnulo,
		FechaAnulo = GETDATE()
	WHERE ID = @ID

	IF @IdCuentaCobrar IS NOT NULL 
	BEGIN
		UPDATE ERP.CuentaCobrar
		SET Flag = 0
		WHERE ID = @IdCuentaCobrar

		SELECT @IdAplicacionAnticipoCobrar = ID,
				@IdAsiento = IdAsiento
		FROM ERP.AplicacionAnticipoCobrar 		
		WHERE IdCuentaCobrar = @IdCuentaCobrar

		DELETE FROM ERP.AplicacionAnticipoCobrarDetalle
		WHERE IdAplicacionAnticipoCobrar = @IdAplicacionAnticipoCobrar

		DELETE FROM ERP.AplicacionAnticipoCobrar
		WHERE ID = @IdAplicacionAnticipoCobrar		

		UPDATE ERP.Asiento
		SET Flag = 0
		WHERE ID = @IdAsiento

		UPDATE ERP.AsientoDetalle
		SET Flag = 0
		WHERE IdAsiento = @IdAsiento
	END
