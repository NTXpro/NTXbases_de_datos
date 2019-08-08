CREATE PROC ERP.Usp_Sel_LiquidacionDetalleOtroDescuento_By_IdLiquidacionDetalle
@IdLiquidacionDetalle INT
AS
BEGIN
	SELECT LDOD.ID
      ,LDOD.IdLiquidacionDetalle
      ,LDOD.IdConcepto
	  ,C.Orden
	  ,C.Nombre NombreConcepto
      ,LDOD.Total
  FROM ERP.LiquidacionDetalleOtroDescuento LDOD
  INNER JOIN ERP.Concepto C ON C.ID = LDOD.IdConcepto
  WHERE IdLiquidacionDetalle = @IdLiquidacionDetalle
END
