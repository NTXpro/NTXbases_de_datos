CREATE PROC ERP.Usp_Sel_LiquidacionDetalleOtroIngreso_By_IdLiquidacionDetalle
@IdLiquidacionDetalle INT
AS
BEGIN
	SELECT LDOI.ID
      ,LDOI.IdLiquidacionDetalle
      ,LDOI.IdConcepto
	  ,C.Orden
	  ,C.Nombre NombreConcepto
      ,LDOI.Total
  FROM ERP.LiquidacionDetalleOtroIngreso LDOI
  INNER JOIN ERP.Concepto C ON C.ID = LDOI.IdConcepto
  WHERE IdLiquidacionDetalle = @IdLiquidacionDetalle
END
