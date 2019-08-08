CREATE PROCEDURE [Maestro].[Usp_Sel_Origen] --1
AS
BEGIN
	SELECT 
	     ID
		,Abreviatura
		,Nombre
		,UsuarioRegistro
		,FechaRegistro
		,UsuarioModifico
		,FechaModificado
		,UsuarioElimino
		,FechaEliminado
		,UsuarioActivo
		,FechaActivacion
		,FlagOrigenAutomatico
		,FlagSistema
		,FlagBorrador
		,Flag
	FROM [Maestro].[Origen]
	WHERE
	FlagBorrador = 0 AND
	Flag = 1
END