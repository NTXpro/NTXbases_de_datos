CREATE PROC [ERP].[Usp_Sel_T12TipoOperacion_Restaurar]
AS
BEGIN
	SELECT
    TOPE.ID,
    TOPE.Nombre,
    TOPE.CodigoSunat,
	TOPE.FechaRegistro
    FROM [PLE].[T12TipoOperacion] TOPE
    WHERE
    TOPE.Flag = 0
END