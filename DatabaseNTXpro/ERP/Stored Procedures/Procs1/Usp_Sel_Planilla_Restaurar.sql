CREATE PROCEDURE [ERP].[Usp_Sel_Planilla_Restaurar]
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
    INNER JOIN Maestro.TipoPlanilla TP ON P.IdTipoPlanilla = TP.ID
    WHERE
    ISNULL(P.Flag, 0) = 0 AND
	P.IdEmpresa = @IdEmpresa
END
