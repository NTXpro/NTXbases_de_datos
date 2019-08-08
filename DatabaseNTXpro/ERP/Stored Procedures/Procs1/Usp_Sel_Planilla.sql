CREATE PROC [ERP].[Usp_Sel_Planilla] --1
@IdEmpresa INT
AS
BEGIN
		
	SELECT
		P.ID,
		P.Nombre,
		P.Codigo,
		P.Dia,
		P.FlagDiaMes,
		TP.ID AS IdTipoPlanilla,
		TP.Nombre AS NombreTipoPlanilla,
		TP.Codigo AS CodigoTipoPlanilla
	FROM [Maestro].[Planilla] P
	INNER JOIN [Maestro].[TipoPlanilla] TP ON P.IdTipoPlanilla = TP.ID
	WHERE 
	P.IdEmpresa = @IdEmpresa AND
	ISNULL(P.FlagBorrador, 0) = 0 AND
	P.Flag = 1

END
