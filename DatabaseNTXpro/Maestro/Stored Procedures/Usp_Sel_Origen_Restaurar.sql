CREATE PROC [Maestro].[Usp_Sel_Origen_Restaurar]
AS
BEGIN
	SELECT
    O.ID,
    O.Nombre,
    O.Abreviatura,
	O.FlagOrigenAutomatico
    FROM Maestro.Origen O	
    WHERE
    O.Flag = 0
END