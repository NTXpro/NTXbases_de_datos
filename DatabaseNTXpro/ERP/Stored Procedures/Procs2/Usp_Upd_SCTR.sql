CREATE PROC [ERP].[Usp_Upd_SCTR]
@IdSctr INT,
@IdDatoLaboral INT,
@IdEmpresa INT,
@IdTipoPension INT,
@IdTipoSalud   INT,
@FechaInicio DATETIME,
@FechaFin DATETIME
AS
BEGIN

			UPDATE ERP.SCTR SET	       	IdTipoPension = @IdTipoPension,
										IdTipoSalud = @IdTipoSalud,
										FechaInicio = @FechaInicio,
										FechaFin = @FechaFin
					WHERE ID = @IdSctr AND IdDatoLaboral = @IdDatoLaboral AND IdEmpresa = @IdEmpresa
END
