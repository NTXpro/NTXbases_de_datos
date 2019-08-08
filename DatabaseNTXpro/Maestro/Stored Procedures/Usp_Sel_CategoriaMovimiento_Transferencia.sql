CREATE PROC [Maestro].[Usp_Sel_CategoriaMovimiento_Transferencia]
AS
BEGIN
	SELECT ID,
		   Nombre,
		   FlagCheque,
		   FlagTransferencia,
		   IdCategoriaTipoMovimientoRelacion
	FROM [Maestro].[CategoriaTipoMovimiento]
	WHERE FlagTransferencia = 1
END