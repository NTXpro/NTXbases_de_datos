CREATE PROCEDURE [ERP].[Usp_Sel_Planilla_By_ID]
@ID INT
AS
BEGIN
	SELECT 
		P.ID,
	    P.Nombre,
		P.Codigo,
		TP.ID AS IdTipoPlanilla,
		TP.Nombre AS NombreTipoPlanilla,
		P.Dia,
		P.FlagDiaMes,
		P.UsuarioRegistro,
		P.FechaRegistro,
		P.UsuarioModifico,
		P.FechaModificado,
		P.UsuarioElimino,
		P.FechaEliminado,
		P.UsuarioActivo,
		P.FechaActivacion,
		P.FlagBorrador,
		P.Flag
	FROM Maestro.Planilla P
	LEFT JOIN Maestro.TipoPlanilla TP ON P.IdTipoPlanilla = TP.ID                                
    WHERE
    P.ID = @ID
END

SELECT * FROM Maestro.Planilla
