
		CREATE PROC [ERP].[Usp_Sel_Forma_De_Pago]  
AS
BEGIN
	SELECT  FP.ID,
			FP.Nombre	FormaPago,
			TP.Nombre	TipoPago,
			FP.Dias
	FROM ERP.FormaPago FP
	INNER JOIN ERP.TipoPago TP
	ON TP.ID= FP.IdTipoPago
END
