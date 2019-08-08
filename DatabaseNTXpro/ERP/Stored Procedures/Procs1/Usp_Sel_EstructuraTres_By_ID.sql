
CREATE PROC [ERP].[Usp_Sel_EstructuraTres_By_ID]
@ID INT
AS
BEGIN
	SELECT 
	   EBGT.ID
      ,EBGT.IdEstructuraDos
      ,EBGT.Nombre
      ,EBGT.Orden
      ,EBGT.UsuarioRegistro
      ,EBGT.FechaRegistro
      ,EBGT.UsuarioModifico
      ,EBGT.FechaModificado
      ,EBGT.UsuarioActivo
      ,EBGT.FechaActivacion
      ,EBGT.UsuarioElimino
      ,EBGT.FechaEliminado
      ,EBGT.Flag
	  ,CONCAT(EBGU.Nombre, ' - ', EBGD.Nombre, ' - ', EBGT.Nombre) AS NombreCompleto
	FROM [ERP].[EstructuraTres] EBGT
	INNER JOIN [ERP].[EstructuraDos] EBGD ON EBGT.IdEstructuraDos = EBGD.ID
	INNER JOIN [ERP].[EstructuraUno] EBGU ON EBGD.IdEstructuraUno = EBGU.ID
	WHERE EBGT.ID = @ID
END
