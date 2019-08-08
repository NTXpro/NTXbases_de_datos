
CREATE PROC [ERP].[Usp_Sel_DatoLaboralPrestamo]
@IdDatoLaboral INT,
@IdEmpresa INT
AS
BEGIN
		SELECT PRE.* ,CO.*, PRE.Descuento  AS Saldo
		FROM ERP.DatoLaboralPrestamo PRE
		INNER JOIN ERP.Concepto CO ON CO.ID = PRE.IdConcepto
		INNER JOIN ERP.DatoLaboral DL ON DL.ID = PRE.IdDatoLaboral
		INNER JOIN ERP.Empresa EM ON EM.ID = PRE.IdEmpresa
		WHERE PRE.IdDatoLaboral = @IdDatoLaboral AND EM.ID = @IdEmpresa

END
