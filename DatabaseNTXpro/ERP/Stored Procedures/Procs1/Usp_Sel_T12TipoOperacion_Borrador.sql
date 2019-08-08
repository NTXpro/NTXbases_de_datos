CREATE PROC [ERP].[Usp_Sel_T12TipoOperacion_Borrador]
AS
BEGIN
	SELECT
    TOPE.ID,
    TOPE.Nombre,
	TOPE.CodigoSunat,
	TOPE.FechaRegistro
    FROM [PLE].[T12TipoOperacion] TOPE
    WHERE
    TOPE.Flag = 1 AND
	TOPE.FlagBorrador = 1 AND
	TOPE.FlagSunat = 0
END