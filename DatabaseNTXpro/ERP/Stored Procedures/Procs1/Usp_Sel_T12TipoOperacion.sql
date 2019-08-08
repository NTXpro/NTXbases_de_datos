CREATE PROCEDURE [ERP].[Usp_Sel_T12TipoOperacion]
AS
BEGIN
	SELECT 
	   ID
      ,CodigoSunat + ' - ' + Nombre AS Nombre
      ,CodigoSunat
      ,UsuarioRegistro
      ,FechaRegistro
      ,UsuarioModifico
      ,FechaModificado
      ,UsuarioElimino
      ,FechaEliminado
      ,UsuarioActivo
      ,FechaActivacion
      ,FlagSunat
      ,FlagBorrador
      ,Flag
	FROM [PLE].[T12TipoOperacion]
	WHERE 
	[Flag] = 1 AND
	[FlagBorrador] = 0 AND
	[FlagSunat] = 1
END