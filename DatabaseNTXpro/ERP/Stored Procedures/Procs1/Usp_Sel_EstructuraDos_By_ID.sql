
CREATE PROC [ERP].[Usp_Sel_EstructuraDos_By_ID]
@ID INT
AS
BEGIN
	SELECT 
	   ED.ID
      ,ED.IdEstructuraUno
      ,ED.Nombre
      ,ED.UsuarioRegistro
      ,ED.FechaRegistro
      ,ED.UsuarioModifico
      ,ED.FechaModificado
      ,ED.UsuarioActivo
      ,ED.FechaActivacion
      ,ED.UsuarioElimino
      ,ED.FechaEliminado
      ,ED.Flag
	FROM [ERP].[EstructuraDos] ED
	WHERE ED.ID = @ID
END
