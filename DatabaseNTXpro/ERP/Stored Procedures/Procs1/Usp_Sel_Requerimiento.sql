CREATE PROC [ERP].[Usp_Sel_Requerimiento] --1
@IdEmpresa INT,
@Filtro VARCHAR(250)
AS
BEGIN
	SELECT R.ID
		  ,R.Fecha
		  ,R.Serie
		  ,R.Documento
		  ,R.IdEntidad
		  ,E.Nombre NombreEntidad
		  ,R.Observacion
		  ,RE.Nombre Estado
  FROM ERP.Requerimiento R
  LEFT JOIN ERP.Entidad E ON E.ID = R.IdEntidad
  LEFT JOIN Maestro.RequerimientoEstado RE ON RE.ID = R.IdRequerimientoEstado
  WHERE R.IdRequerimientoEstado != 2
  AND R.FlagBorrador = 0 AND R.IdEmpresa = @IdEmpresa
  AND ((@Filtro = '' OR R.Serie like '%' + @Filtro + '%') 
  OR (@Filtro = '' OR R.Documento like '%' + @Filtro + '%') 
  OR (@Filtro = '' OR E.Nombre like '%' + @Filtro + '%'))
  ORDER BY R.Fecha ASC
END
