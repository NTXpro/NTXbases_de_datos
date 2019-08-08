CREATE PROC [Maestro].[Usp_Sel_Origen_Borrador]
AS
BEGIN
	SELECT
    O.ID,
    O.Nombre,
    O.Abreviatura,
	O.FlagOrigenAutomatico
    FROM Maestro.Origen O	
    WHERE
    O.Flag = 1 AND
	O.FlagBorrador = 1
END