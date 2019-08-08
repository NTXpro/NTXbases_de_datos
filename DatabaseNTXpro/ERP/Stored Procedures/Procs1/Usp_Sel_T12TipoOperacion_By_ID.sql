
CREATE PROCEDURE [ERP].[Usp_Sel_T12TipoOperacion_By_ID] --1
@ID INT
AS
BEGIN
	SELECT 
	   [ID]
      ,[Nombre]
      ,[CodigoSunat]
	  ,[IdTipoMovimiento]
      ,[UsuarioRegistro]
      ,[FechaRegistro]
      ,[UsuarioModifico]
      ,[FechaModificado]
      ,[UsuarioElimino]
      ,[FechaEliminado]
      ,[UsuarioActivo]
      ,[FechaActivacion]
      ,[FlagSunat]
	  ,[FlagCostear]
      ,[FlagBorrador]
      ,[Flag]
	FROM [PLE].[T12TipoOperacion]
    WHERE
    ID = @ID
END
