
CREATE PROC [ERP].[Usp_Upd_Comprobante_ResumenDiario]
@Fecha DATETIME,
@IdEmpresa INT
AS
BEGIN
	UPDATE [ERP].[Comprobante] SET FlagResumenDiario = 1 
	 WHERE CAST(Fecha AS DATE) = CAST(@Fecha AS DATE) AND IdEmpresa = @IdEmpresa
				 AND IdTipoComprobante IN (4,189) AND IdComprobanteEstado = 2	
					
	UPDATE [ERP].[Comprobante] SET FlagResumenDiario = 1 
	 WHERE ID IN (SELECT C.ID FROM ERP.Comprobante C INNER JOIN ERP.ComprobanteReferencia CR
				  ON CR.IdComprobante = C.ID
				  INNER JOIN ERP.Comprobante COR 
				  ON COR.ID = CR.IdReferencia
				  WHERE COR.IdTipoComprobante IN (4,189) AND C.IdTipoComprobante IN (8,9) AND CR.FlagInterno = 1 AND C.IdComprobanteEstado = 2)				
END
