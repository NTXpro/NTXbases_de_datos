CREATE PROC [ERP].[Usp_Sel_Establecimiento_Borrador]
@IdEntidad INT
AS
BEGIN
	SELECT
    E.ID,
    E.Nombre,
    E.Direccion
    FROM ERP.Establecimiento E
    WHERE E.IdEntidad = @IdEntidad AND
    Flag = 1 AND
	FlagBorrador = 1
END
