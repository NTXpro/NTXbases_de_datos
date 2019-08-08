CREATE PROC [ERP].[Usp_Upd_FechaFin]
@IdDatoLaboral INT,
@IdEmpresa  INT,
@FechaFin DATETIME
AS
BEGIN
		WITH Salud AS (
		SELECT FechaFin,Ordercacion = ROW_NUMBER() OVER (ORDER BY ID)
		FROM ERP.Salud WHERE IdDatoLaboral = @IdDatoLaboral AND IdEmpresa = @IdEmpresa
		)

		UPDATE P SET P.FechaFin = @FechaFin
		FROM 
		Salud P INNER JOIN Salud S ON P.Ordercacion = S.Ordercacion - 1
END
