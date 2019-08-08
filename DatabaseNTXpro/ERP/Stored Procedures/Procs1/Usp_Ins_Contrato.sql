CREATE PROC [ERP].[Usp_Ins_Contrato]
@IdContrato INT OUT,
@IdDatoLaboral INT,
@IdTipoContrato INT,
@IdEmpresa INT,
@FechaInicio DATETIME,
@FechaFin DATETIME,
@Adjunto VARCHAR(MAX)
AS
BEGIN

			INSERT INTO ERP.Contrato(
										IdDatoLaboral,
										IdEmpresa,
										IdTipoContrato,
										FechaInicio,
										FechaFin,
										Adjunto
									)
									VALUES(
											@IdDatoLaboral,
											@IdEmpresa,
											@IdTipoContrato,
											@FechaInicio,
											@FechaFin,
											@Adjunto
											)
				SET @IdContrato = SCOPE_IDENTITY();

				SELECT @IdContrato
END
