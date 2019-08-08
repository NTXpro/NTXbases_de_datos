
CREATE PROC [ERP].[Usp_Sel_OrdenCompra_No_Importado] --1
@IdEmpresa INT,
@Filtro VARCHAR(250)
AS
BEGIN
	
	DECLARE @ParametroRequiereAprobacion VARCHAR(1) = ISNULL((SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](@IdEmpresa, 'LIOCSA', GETDATE())),'1')

	SELECT OC.ID
		  ,OC.Fecha
		  ,OC.Serie
		  ,OC.Documento
		  ,E.ID IdEntidad
		  ,E.Nombre NombreProveedor
		  ,OC.Observacion
		  ,OCE.Nombre Estado
  FROM ERP.OrdenCompra OC
  LEFT JOIN ERP.Proveedor P ON P.ID = OC.IdProveedor
  LEFT JOIN ERP.Entidad E ON E.ID = P.IdEntidad
  LEFT JOIN Maestro.OrdenCompraEstado OCE ON OCE.ID = OC.IdOrdenCompraEstado
  WHERE ((@ParametroRequiereAprobacion = '1' AND OC.IdOrdenCompraEstado IN (1,3,6)) 
  OR (@ParametroRequiereAprobacion = '0' AND OC.IdOrdenCompraEstado IN (3,6)))
  AND OC.IdEmpresa = @IdEmpresa AND OC.Flag = 1 AND OC.FlagBorrador = 0
  AND ((@Filtro = '' OR OC.Serie like '%' + @Filtro + '%') 
  OR (@Filtro = '' OR OC.Documento like '%' + @Filtro + '%') 
  OR (@Filtro = '' OR E.Nombre like '%' + @Filtro + '%'))
  ORDER BY OC.Fecha ASC
END