CREATE PROC [ERP].[Usp_Ins_SCTR]
@IdSctr INT OUT,
@IdDatoLaboral INT,
@IdEmpresa INT,
@IdTipoPension INT,
@IdTipoSalud   INT,
@FechaInicio DATETIME,
@FechaFin DATETIME
AS
BEGIN

			INSERT INTO ERP.SCTR(
										IdDatoLaboral,
										IdEmpresa,
										IdTipoPension,
										IdTipoSalud,
										FechaInicio,
										FechaFin
									)
									VALUES(
											@IdDatoLaboral,
											@IdEmpresa,
											@IdTipoPension,
											@IdTipoSalud,
											@FechaInicio,
											@FechaFin
											)
				SET @IdSctr = SCOPE_IDENTITY();

				SELECT @IdSctr
END
