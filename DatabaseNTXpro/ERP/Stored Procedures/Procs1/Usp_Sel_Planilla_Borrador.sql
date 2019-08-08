CREATE PROCEDURE [ERP].[Usp_Sel_Planilla_Borrador]
@IdEmpresa INT
AS
BEGIN
	SELECT
	    P.ID,
	    P.Nombre,
	    P.Codigo,
	    TP.ID AS IdTipoPlanilla,
	    TP.Nombre AS NombreTipoPlanilla,
	    P.Dia,
	    P.FlagDiaMes
    FROM Maestro.Planilla P
    LEFT JOIN Maestro.TipoPlanilla TP ON P.IdTipoPlanilla = TP.ID
    WHERE
	P.IdEmpresa = @IdEmpresa AND
    P.FlagBorrador = 1 AND
	P.Flag = 1
END
