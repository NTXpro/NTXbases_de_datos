CREATE PROCEDURE [Maestro].[Usp_Sel_Origen_By_ID] --1
@ID INT
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
    ID = @ID
END