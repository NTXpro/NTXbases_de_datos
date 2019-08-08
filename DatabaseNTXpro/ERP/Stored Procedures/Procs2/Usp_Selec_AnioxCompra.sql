CREATE PROC [ERP].[Usp_Selec_AnioxCompra]
@IdCompra INT
AS
BEGIN

			DECLARE @IdPerido INT = (SELECT IdPeriodo FROM ERP.Compra WHERE ID = @IdCompra)

			SELECT CAST(AN.Nombre AS INT)
			FROM ERP.Periodo PE
			INNER JOIN Maestro.Anio AN
			ON AN.ID = PE.IdAnio
			WHERE PE.ID = @IdPerido

END
