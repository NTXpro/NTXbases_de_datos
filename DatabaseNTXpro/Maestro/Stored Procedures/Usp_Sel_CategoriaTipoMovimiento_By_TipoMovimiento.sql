CREATE PROC [Maestro].[Usp_Sel_CategoriaTipoMovimiento_By_TipoMovimiento]
@IdTipoMovimiento INT
AS
BEGIN
	SELECT ID, IdTipoMovimiento, Nombre, Abreviatura,FlagCheque
	FROM Maestro.CategoriaTipoMovimiento
	WHERE IdTipoMovimiento = @IdTipoMovimiento
END