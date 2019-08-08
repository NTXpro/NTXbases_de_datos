
CREATE PROC [ERP].[Usp_Sel_ValeTransferencia_By_ID]
@Id INT
AS
BEGIN
	SELECT VT.[ID]
      ,VT.[IdEmpresa]
      ,VT.[IdAlmacenOrigen]
	  ,AO.Nombre NombreAlmacenOrigen
      ,VT.[IdAlmacenDestino]
	  ,AD.Nombre NombreAlmacenDestino
	  ,M.Nombre Moneda
      ,VT.[Fecha]
      ,VT.[Documento]
      ,VT.[Observacion]
      ,VT.[SubTotal]
      ,VT.[IGV]
      ,VT.[Total]
      ,VT.[Flag]
      ,VT.[FlagBorrador]
      ,VT.[FechaRegistro]
      ,VT.[UsuarioRegistro]
      ,VT.[UsuarioModifico]
      ,VT.[FechaModificado]
      ,VT.[UsuarioElimino]
      ,VT.[FechaEliminado]
      ,VT.[UsuarioActivo]
      ,VT.[FechaActivacion]
      ,VT.[IdMoneda]
      ,VT.[TipoCambio]
      ,VT.[PorcentajeIGV]
      ,VT.[IdValeOrigen]
      ,VT.[IdValeDestino]
	  ,VO.Documento NumeroValeOrigen
	  ,VD.Documento NumeroValeDestino
  FROM [ERP].[ValeTransferencia] VT
  LEFT JOIN ERP.Almacen AO ON AO.ID = VT.IdAlmacenOrigen
  LEFT JOIN ERP.Almacen AD ON AD.ID = VT.IdAlmacenDestino
  LEFT JOIN Maestro.Moneda M ON M.ID = VT.IdMoneda
  LEFT JOIN ERP.Vale VO ON VO.ID = VT.IdValeOrigen
  LEFT JOIN ERP.Vale VD ON VD.ID = VT.IdValeDestino
  WHERE VT.ID = @Id
END
