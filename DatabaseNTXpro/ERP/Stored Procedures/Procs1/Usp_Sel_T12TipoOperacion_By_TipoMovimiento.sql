
CREATE proc [ERP].[Usp_Sel_T12TipoOperacion_By_TipoMovimiento]
@IdTipoMovimiento  INT
AS
BEGIN
	SELECT [ID]
      ,[Nombre]
      ,[CodigoSunat]
  FROM [PLE].[T12TipoOperacion]
  WHERE IdTipoMovimiento = @IdTipoMovimiento AND FlagBorrador = 0 AND Flag = 1
END
