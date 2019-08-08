
CREATE PROC [ERP].[Usp_Sel_TransformacionServicio_By_Nombre]
@Nombre VARCHAR(250)
AS
BEGIN
	SELECT [ID]
      ,[Nombre]
      ,[Descripcion]
      ,[UsuarioRegistro]
      ,[FechaRegistro]
      ,[UsuarioModifico]
      ,[FechaModificado]
      ,[UsuarioActivo]
      ,[FechaActivacion]
      ,[UsuarioElimino]
      ,[FechaEliminado]
      ,[FlagBorrador]
      ,[Flag]
	FROM [Maestro].[TransformacionServicio]
	WHERE
	(@Nombre IS NULL OR @Nombre = '' OR [Nombre] = @Nombre)AND
	([FlagBorrador] IS NULL OR [FlagBorrador] = 0) AND
	[Flag] = 1
END
