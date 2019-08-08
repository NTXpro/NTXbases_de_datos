CREATE PROC [ERP].[Usp_Upd_Contrato]
@IdContrato INT,
@IdDatoLaboral INT,
@IdEmpresa INT,
@IdTipoContrato INT,
@FechaInicio DATETIME,
@FechaFin DATETIME,
@Adjunto VARCHAR(MAX)
AS
BEGIN
		UPDATE ERP.Contrato SET FechaInicio = @FechaInicio , FechaFin = @FechaFin , Adjunto = @Adjunto , IdTipoContrato = @IdTipoContrato
		WHERE ID = @IdContrato AND IdDatoLaboral = @IdDatoLaboral AND IdEmpresa = @IdEmpresa

END
