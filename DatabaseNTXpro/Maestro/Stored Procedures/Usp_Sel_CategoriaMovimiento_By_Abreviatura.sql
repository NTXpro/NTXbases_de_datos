CREATE PROC Maestro.Usp_Sel_CategoriaMovimiento_By_Abreviatura
@Abreviatura VARCHAR(50)
AS
BEGIN
	
	SELECT [ID]
      ,[IdTipoMovimiento]
      ,[Nombre]
      ,[Abreviatura]
      ,[FlagCheque]
      ,[FlagTransferencia]
      ,[IdCategoriaTipoMovimientoRelacion]
	FROM [Maestro].[CategoriaTipoMovimiento]
	WHERE Abreviatura = @Abreviatura

END